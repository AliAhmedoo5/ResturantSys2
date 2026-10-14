import 'dart:convert';
import 'dart:typed_data';

import 'package:pos_security/key_recovery.dart';
import 'package:test/test.dart';

void main() {
  test('portable encrypted recovery restores the original installation key', () async {
    final key = Uint8List.fromList(List.generate(32, (i) => i + 1));
    final kit = await KeyRecovery.create(key);
    expect(await KeyRecovery.recover(recoveryCode: kit.recoveryCode,
      encryptedEnvelope: kit.encryptedEnvelope), key);
    expect(kit.encryptedEnvelope, isNot(contains(kit.recoveryCode)));
    expect(kit.encryptedEnvelope, isNot(contains(base64UrlEncode(key))));
    expect(kit.toString(), 'KeyRecoveryKit(redacted)');
    final second = await KeyRecovery.create(key);
    expect(second.recoveryCode, isNot(kit.recoveryCode));
    expect(second.encryptedEnvelope, isNot(kit.encryptedEnvelope));
  });
  test('wrong recovery code and altered ciphertext are refused', () async {
    final kit = await KeyRecovery.create(Uint8List(32));
    await expectLater(KeyRecovery.recover(recoveryCode: base64UrlEncode(List.filled(32, 0)),
      encryptedEnvelope: kit.encryptedEnvelope), throwsA(isA<KeyRecoveryFailure>()));
    final changed = base64Url.decode(kit.encryptedEnvelope.substring(6));
    changed[20] ^= 1;
    await expectLater(KeyRecovery.recover(recoveryCode: kit.recoveryCode,
      encryptedEnvelope: 'CCRK1.${base64UrlEncode(changed)}'), throwsA(isA<KeyRecoveryFailure>()));
  });
  test('unsupported format, oversized envelope and malformed code fail closed', () async {
    final kit = await KeyRecovery.create(Uint8List(32));
    for (final envelope in ['CCRK2.${kit.encryptedEnvelope.substring(6)}', '', 'x' * 100000]) {
      await expectLater(KeyRecovery.recover(recoveryCode: kit.recoveryCode,
        encryptedEnvelope: envelope), throwsA(isA<KeyRecoveryFailure>()));
    }
    await expectLater(KeyRecovery.recover(recoveryCode: '!' * 44,
      encryptedEnvelope: kit.encryptedEnvelope), throwsA(isA<KeyRecoveryFailure>()));
  });
}
