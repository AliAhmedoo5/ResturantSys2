import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

final class KeyRecoveryFailure implements Exception {
  const KeyRecoveryFailure();
  @override
  String toString() => 'Installation-key recovery could not be verified.';
}

/// Show the code once for offline safekeeping, separately from the encrypted
/// envelope. Never persist the code alongside the envelope or in diagnostics.
final class KeyRecoveryKit {
  const KeyRecoveryKit._(this.recoveryCode, this.encryptedEnvelope);
  final String recoveryCode;
  final String encryptedEnvelope;
  @override
  String toString() => 'KeyRecoveryKit(redacted)';
}

/// Portable key recovery primitive; does not authorize account reset or restore.
/// A future recovery workflow must require owner-held evidence and audit access.
abstract final class KeyRecovery {
  static const _prefix = 'CCRK1.';
  static final _context = utf8.encode(
    'crunch-cartel/installation-key-recovery/v1',
  );

  static Future<KeyRecoveryKit> create(Uint8List installationKey) async {
    if (installationKey.length != 32)
      throw ArgumentError('Invalid installation key.');
    final cipher = AesGcm.with256bits();
    final secret = await cipher.newSecretKey();
    final plaintext = Uint8List.fromList(installationKey);
    try {
      final box = await cipher.encrypt(
        plaintext,
        secretKey: secret,
        aad: _context,
      );
      final code = base64UrlEncode(await secret.extractBytes());
      return KeyRecoveryKit._(
        code,
        '$_prefix${base64UrlEncode(box.concatenation())}',
      );
    } finally {
      plaintext.fillRange(0, plaintext.length, 0);
      secret.destroy();
    }
  }

  static Future<Uint8List> recover({
    required String recoveryCode,
    required String encryptedEnvelope,
  }) async {
    // Exact sizes bound decoding and reject version confusion before crypto work.
    if (recoveryCode.length != 44 ||
        encryptedEnvelope.length != _prefix.length + 80 ||
        !encryptedEnvelope.startsWith(_prefix)) {
      throw const KeyRecoveryFailure();
    }
    Uint8List key;
    Uint8List envelope;
    try {
      key = base64Url.decode(recoveryCode);
      envelope = base64Url.decode(encryptedEnvelope.substring(_prefix.length));
    } on FormatException {
      throw const KeyRecoveryFailure();
    }
    if (key.length != 32 || envelope.length != 60) {
      key.fillRange(0, key.length, 0);
      throw const KeyRecoveryFailure();
    }
    final secret = SecretKey(key);
    try {
      final box = SecretBox.fromConcatenation(
        envelope,
        nonceLength: 12,
        macLength: 16,
      );
      final recovered = await AesGcm.with256bits().decrypt(
        box,
        secretKey: secret,
        aad: _context,
      );
      if (recovered.length != 32) throw const KeyRecoveryFailure();
      return Uint8List.fromList(recovered);
    } on SecretBoxAuthenticationError {
      throw const KeyRecoveryFailure();
    } finally {
      secret.destroy();
      key.fillRange(0, key.length, 0);
    }
  }
}
