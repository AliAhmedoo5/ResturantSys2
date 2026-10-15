import 'dart:convert';
import 'dart:typed_data';

import 'package:pos_security/pin_security.dart';
import 'package:test/test.dart';

void main() {
  test(
    'PIN syntax preserves leading zeroes and primary Cashier requires four digits',
    () {
      for (final pin in ['0007', '12345678']) {
        PinSecurity.validate(pin);
      }
      PinSecurity.validate('0007', primaryCashier: true);
      for (final pin in [
        '',
        '123',
        '123456789',
        ' 1234',
        '1234 ',
        '１２３４',
        '12a4',
        '1234\n',
      ]) {
        expect(() => PinSecurity.validate(pin), throwsArgumentError);
      }
      expect(
        () => PinSecurity.validate('12345', primaryCashier: true),
        throwsArgumentError,
      );
    },
  );
  test(
    'salted Argon2id verifier round-trips and rejects a different PIN',
    () async {
      final first = await PinSecurity.createVerifier('0027');
      final second = await PinSecurity.createVerifier('0027');
      expect(first.saltBase64, isNot(second.saltBase64));
      expect(first.hashBase64, isNot(second.hashBase64));
      expect(await PinSecurity.verify('0027', first), isTrue);
      expect(await PinSecurity.verify('0028', first), isFalse);
      final stored = PinVerifierRecord(
        saltBase64: first.saltBase64,
        hashBase64: first.hashBase64,
      );
      expect(await PinSecurity.verify('0027', stored), isTrue);
      expect(first.toString(), isNot(contains('0027')));
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
  test('fingerprint is stable, PIN-sensitive and installation-keyed', () async {
    final key = Uint8List.fromList(List.generate(32, (i) => i));
    final first = await PinSecurity.fingerprint('0027', key);
    expect(await PinSecurity.fingerprint('0027', key), first);
    expect(await PinSecurity.fingerprint('0028', key), isNot(first));
    expect(await PinSecurity.fingerprint('0027', Uint8List(32)), isNot(first));
    expect(key, List.generate(32, (i) => i));
    expect(base64Decode(first).length, 32);
    await expectLater(
      PinSecurity.fingerprint('0027', Uint8List(31)),
      throwsArgumentError,
    );
  });
  test('malformed or downgraded verifier cannot change resource costs', () {
    final salt = base64Encode(List.filled(16, 0));
    final hash = base64Encode(List.filled(32, 0));
    expect(
      () =>
          PinVerifierRecord(saltBase64: salt, hashBase64: hash, iterations: 1),
      throwsFormatException,
    );
    expect(
      () => PinVerifierRecord(
        saltBase64: salt,
        hashBase64: hash,
        memoryKiB: 1 << 30,
      ),
      throwsFormatException,
    );
    expect(
      () => PinVerifierRecord(saltBase64: 'bad', hashBase64: hash),
      throwsFormatException,
    );
    expect(
      () => PinVerifierRecord(saltBase64: salt, hashBase64: '!'),
      throwsFormatException,
    );
  });
}
