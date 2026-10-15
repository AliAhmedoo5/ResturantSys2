@TestOn('windows')
library;

import 'dart:typed_data';
import 'package:pos_security/windows_key_protection.dart';
import 'package:test/test.dart';

void main() {
  test('DPAPI round-trip uses randomized encrypted envelopes', () {
    final key = Uint8List.fromList(List.generate(32, (i) => i + 1));
    final envelope = WindowsKeyProtection.protect(key);
    expect(envelope, isNot(key));
    expect(WindowsKeyProtection.protect(key), isNot(envelope));
    expect(WindowsKeyProtection.unprotect(envelope), key);
    expect(key, List.generate(32, (i) => i + 1));
  });
  test(
    'corrupt or invalid envelopes fail without returning a replacement key',
    () {
      final envelope = WindowsKeyProtection.protect(Uint8List(32));
      envelope[envelope.length - 1] ^= 255;
      expect(
        () => WindowsKeyProtection.unprotect(envelope),
        throwsA(isA<KeyProtectionFailure>()),
      );
      expect(
        () => WindowsKeyProtection.unprotect(Uint8List(0)),
        throwsA(isA<KeyProtectionFailure>()),
      );
      expect(
        () => WindowsKeyProtection.protect(Uint8List(31)),
        throwsArgumentError,
      );
    },
  );
}
