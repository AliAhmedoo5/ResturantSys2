import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

import 'key_recovery.dart';
import 'pin_security.dart';
import 'windows_key_protection.dart';

final class InstallationKeyExists implements Exception {
  const InstallationKeyExists();
  @override
  String toString() => 'An installation key already exists and was not replaced.';
}

final class InstallationKeyInvalid implements Exception {
  const InstallationKeyInvalid();
  @override
  String toString() => 'Installation key storage is invalid or does not match this database.';
}

/// Prepare before publishing: the onboarding UI must arrange owner safekeeping
/// and acknowledgement of the recovery code before committing the key file.
final class PreparedInstallationKey {
  const PreparedInstallationKey._({required this.keyId, required this.recoveryCode,
    required this.recoveryEnvelope, required String protectedKey,
    required String authenticationTag}) : _protectedKey = protectedKey,
      _authenticationTag = authenticationTag;

  final String keyId, recoveryCode, recoveryEnvelope;
  final String _protectedKey, _authenticationTag;

  static Future<PreparedInstallationKey> create() async {
    final random = Random.secure();
    final key = Uint8List.fromList(List.generate(32, (_) => random.nextInt(256)));
    try {
      final recovery = await KeyRecovery.create(key);
      final id = await _identifier(key);
      final protected = base64Encode(WindowsKeyProtection.protect(key));
      return PreparedInstallationKey._(keyId: id,
        recoveryCode: recovery.recoveryCode, recoveryEnvelope: recovery.encryptedEnvelope,
        protectedKey: protected, authenticationTag: await _manifestTag(key, id,
          protected, recovery.encryptedEnvelope));
    } finally { key.fillRange(0, key.length, 0); }
  }

  /// Recovery requires an expected ID from the selected database. It produces a
  /// new DPAPI envelope but cannot overwrite an existing key store.
  static Future<PreparedInstallationKey> recover({required String expectedKeyId,
    required String recoveryCode, required String recoveryEnvelope}) async {
    _validateId(expectedKeyId);
    final key = await KeyRecovery.recover(recoveryCode: recoveryCode,
      encryptedEnvelope: recoveryEnvelope);
    try {
      if (await _identifier(key) != expectedKeyId) throw const InstallationKeyInvalid();
      final protected = base64Encode(WindowsKeyProtection.protect(key));
      return PreparedInstallationKey._(keyId: expectedKeyId,
        recoveryCode: recoveryCode, recoveryEnvelope: recoveryEnvelope,
        protectedKey: protected, authenticationTag: await _manifestTag(key,
          expectedKeyId, protected, recoveryEnvelope));
    } finally { key.fillRange(0, key.length, 0); }
  }

  @override
  String toString() => 'PreparedInstallationKey(redacted)';
}

/// The caller must dispose this handle on session teardown/application close.
/// The decrypted installation key is not exposed as a public field.
final class LoadedInstallationKey {
  LoadedInstallationKey._(this.keyId, this._bytes);
  final String keyId;
  final Uint8List _bytes;
  bool _disposed = false;

  Future<String> fingerprint(String pin) {
    if (_disposed) throw StateError('Installation key was disposed.');
    return PinSecurity.fingerprint(pin, _bytes);
  }

  void dispose() {
    _bytes.fillRange(0, _bytes.length, 0);
    _disposed = true;
  }

  @override
  String toString() => 'LoadedInstallationKey(redacted)';
}

/// Existing caller-provisioned local directory only. ACL/known-folder setup is
/// a separate prerequisite; this seam must not be used as that security check.
final class InstallationKeyStore {
  InstallationKeyStore(this.directory);
  final Directory directory;
  static const fileName = 'installation-key.json';

  Future<void> initialize(PreparedInstallationKey prepared) async {
    final canonical = await _directory();
    final destination = File.fromUri(canonical.uri.resolve(fileName));
    if (await FileSystemEntity.type(destination.path, followLinks: false) != FileSystemEntityType.notFound) {
      throw const InstallationKeyExists();
    }
    final pending = await canonical.createTemp('.key-pending-');
    try {
      final staged = File.fromUri(pending.uri.resolve(fileName));
      await staged.writeAsString(jsonEncode({
        'formatVersion': 1, 'keyId': prepared.keyId,
        'protectedKey': prepared._protectedKey,
        'recoveryEnvelope': prepared.recoveryEnvelope,
        'authenticationTag': prepared._authenticationTag,
      }), flush: true);
      // Same-volume publication, explicitly WITHOUT REPLACE_EXISTING. Dart's
      // File.rename can overwrite a destination and is not suitable here.
      final published = using((arena) => MoveFileEx(arena.pcwstr(staged.path),
        arena.pcwstr(destination.path), const MOVE_FILE_FLAGS(8)).value);
      if (!published) {
        if (await FileSystemEntity.type(destination.path, followLinks: false) != FileSystemEntityType.notFound) {
          throw const InstallationKeyExists();
        }
        throw const FileSystemException('Installation-key publication failed.');
      }
      final check = await load(expectedKeyId: prepared.keyId);
      check.dispose();
    } finally {
      // Only this operation's unique staging folder; never delete a published key.
      await pending.delete(recursive: true);
    }
  }

  Future<LoadedInstallationKey> load({required String expectedKeyId}) async {
    _validateId(expectedKeyId);
    final canonical = await _directory();
    final file = File.fromUri(canonical.uri.resolve(fileName));
    final type = await FileSystemEntity.type(file.path, followLinks: false);
    if (type == FileSystemEntityType.notFound) {
      throw const FileSystemException('Installation key is missing.');
    }
    if (type != FileSystemEntityType.file || await file.length() > 32768) {
      throw const InstallationKeyInvalid();
    }
    Map<String, dynamic> data;
    Uint8List protected;
    try {
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is! Map<String, dynamic> || decoded.length != 5 ||
          decoded['formatVersion'] != 1 || decoded['keyId'] != expectedKeyId ||
          decoded['protectedKey'] is! String || decoded['recoveryEnvelope'] is! String ||
          decoded['authenticationTag'] is! String ||
          (decoded['authenticationTag'] as String).length != 44 ||
          (decoded['recoveryEnvelope'] as String).length != 86 ||
          !(decoded['recoveryEnvelope'] as String).startsWith('CCRK1.')) {
        throw const InstallationKeyInvalid();
      }
      data = decoded;
      protected = base64Decode(data['protectedKey'] as String);
    } on FormatException { throw const InstallationKeyInvalid(); }
    final key = WindowsKeyProtection.unprotect(protected);
    try {
      if (await _identifier(key) != expectedKeyId) throw const InstallationKeyInvalid();
      final actualTag = await _manifestTag(key, expectedKeyId,
        data['protectedKey'] as String, data['recoveryEnvelope'] as String);
      final expectedTag = data['authenticationTag'] as String;
      var difference = 0;
      for (var i = 0; i < 44; i++) {
        difference |= actualTag.codeUnitAt(i) ^ expectedTag.codeUnitAt(i);
      }
      if (difference != 0) throw const InstallationKeyInvalid();
      return LoadedInstallationKey._(expectedKeyId, key);
    } catch (_) { key.fillRange(0, key.length, 0); rethrow; }
  }

  Future<Directory> _directory() async {
    if (!Platform.isWindows) throw UnsupportedError('Windows key storage is required.');
    void validate(Directory value) {
      if (!value.isAbsolute || value.path.startsWith(r'\\') || value.path.startsWith('//')) {
        throw ArgumentError('An absolute local key directory is required.');
      }
    }
    validate(directory);
    final canonical = Directory(await directory.resolveSymbolicLinks());
    validate(canonical);
    return canonical;
  }
}

Future<String> _identifier(Uint8List key) async => base64UrlEncode((await Sha256().hash(key)).bytes);

Future<String> _manifestTag(Uint8List key, String id, String protected,
    String recovery) async {
  final secret = SecretKey(List<int>.from(key));
  try {
    final mac = await Hmac.sha256().calculateMac(
      utf8.encode('crunch-cartel/key-file/v1:$id:$protected:$recovery'), secretKey: secret);
    return base64Encode(mac.bytes);
  } finally { secret.destroy(); }
}

void _validateId(String id) {
  try {
    if (id.length != 44 || base64Url.decode(id).length != 32) throw const FormatException();
  } on FormatException { throw const InstallationKeyInvalid(); }
}
