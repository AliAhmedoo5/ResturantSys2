import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

final class KeyProtectionFailure implements Exception {
  const KeyProtectionFailure();
  @override
  String toString() => 'Windows could not protect or recover the installation key.';
}

/// Current-Windows-user DPAPI only. Never uses machine-wide protection or UI.
/// This primitive does not persist keys or implement replacement-device recovery.
abstract final class WindowsKeyProtection {
  static Uint8List protect(Uint8List key) {
    if (key.length != 32) throw ArgumentError('Installation key must be 32 bytes.');
    return _transform(key, encrypt: true);
  }

  static Uint8List unprotect(Uint8List envelope) {
    if (envelope.isEmpty || envelope.length > 16384) throw const KeyProtectionFailure();
    final key = _transform(envelope, encrypt: false);
    if (key.length != 32) {
      key.fillRange(0, key.length, 0);
      throw const KeyProtectionFailure();
    }
    return key;
  }

  static Uint8List _transform(Uint8List bytes, {required bool encrypt}) {
    if (!Platform.isWindows) throw UnsupportedError('Windows DPAPI is required.');
    final input = calloc<CRYPT_INTEGER_BLOB>();
    final output = calloc<CRYPT_INTEGER_BLOB>();
    final buffer = calloc<Uint8>(bytes.length);
    try {
      buffer.asTypedList(bytes.length).setAll(0, bytes);
      input.ref.cbData = bytes.length;
      input.ref.pbData = buffer;
      final result = encrypt
          ? CryptProtectData(input, null, null, null, CRYPTPROTECT_UI_FORBIDDEN, output)
          : CryptUnprotectData(input, null, null, null, CRYPTPROTECT_UI_FORBIDDEN, output);
      if (!result.value) throw const KeyProtectionFailure();
      if (output.ref.cbData <= 0 || output.ref.cbData > 16384) {
        throw const KeyProtectionFailure();
      }
      return Uint8List.fromList(output.ref.pbData.asTypedList(output.ref.cbData));
    } finally {
      buffer.asTypedList(bytes.length).fillRange(0, bytes.length, 0);
      calloc.free(buffer);
      if (output.ref.pbData != nullptr) {
        output.ref.pbData.asTypedList(output.ref.cbData).fillRange(0, output.ref.cbData, 0);
        LocalFree(HLOCAL(output.ref.pbData.cast()));
      }
      calloc.free(input);
      calloc.free(output);
    }
  }
}
