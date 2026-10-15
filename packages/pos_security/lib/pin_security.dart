import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

/// Versioned storage value. Contains only salt and verifier, never a PIN.
final class PinVerifierRecord {
  PinVerifierRecord({
    required this.saltBase64,
    required this.hashBase64,
    this.formatVersion = 1,
    this.memoryKiB = 19456,
    this.iterations = 2,
    this.parallelism = 1,
  }) {
    if (formatVersion != 1 ||
        memoryKiB != 19456 ||
        iterations != 2 ||
        parallelism != 1) {
      throw const FormatException('Unsupported PIN verifier parameters.');
    }
    try {
      if (saltBase64.length != 24 ||
          hashBase64.length != 44 ||
          base64Decode(saltBase64).length != 16 ||
          base64Decode(hashBase64).length != 32) {
        throw const FormatException();
      }
    } on FormatException {
      throw const FormatException('Invalid PIN verifier encoding.');
    }
  }

  final String saltBase64, hashBase64;
  final int formatVersion, memoryKiB, iterations, parallelism;

  @override
  String toString() => 'PinVerifierRecord(redacted)';
}

abstract final class PinSecurity {
  /// No trimming, Unicode conversion or integer parsing: leading zeroes matter.
  static void validate(String pin, {bool primaryCashier = false}) {
    if (pin.length < 4 ||
        pin.length > (primaryCashier ? 4 : 8) ||
        pin.codeUnits.any((unit) => unit < 48 || unit > 57)) {
      throw ArgumentError(
        primaryCashier
            ? 'Primary Cashier PIN must contain exactly four digits.'
            : 'PIN must contain four to eight digits.',
      );
    }
  }

  static Future<PinVerifierRecord> createVerifier(
    String pin, {
    bool primaryCashier = false,
  }) async {
    validate(pin, primaryCashier: primaryCashier);
    final random = Random.secure();
    final salt = List<int>.generate(16, (_) => random.nextInt(256));
    final hash = await _derive(pin, salt);
    return PinVerifierRecord(
      saltBase64: base64Encode(salt),
      hashBase64: base64Encode(hash),
    );
  }

  /// Caller must enforce persisted attempt throttling before invoking this.
  static Future<bool> verify(String pin, PinVerifierRecord record) async {
    validate(pin);
    final actual = await _derive(pin, base64Decode(record.saltBase64));
    final expected = base64Decode(record.hashBase64);
    var difference = 0;
    // Fixed 32-byte comparison, with no early exit for a differing byte.
    for (var i = 0; i < 32; i++) {
      difference |= actual[i] ^ expected[i];
    }
    return difference == 0;
  }

  /// Key comes from Windows-protected installation storage, never SQLite.
  /// Equality is installation-scoped; this is not a fast PIN verifier.
  static Future<String> fingerprint(
    String pin,
    Uint8List installationKey,
  ) async {
    validate(pin);
    if (installationKey.length != 32)
      throw ArgumentError('Invalid installation key.');
    final keyCopy = Uint8List.fromList(installationKey);
    final key = SecretKey(keyCopy);
    try {
      final mac = await Hmac.sha256().calculateMac(
        utf8.encode('crunch-cartel/pin-fingerprint/v1:$pin'),
        secretKey: key,
      );
      return base64Encode(mac.bytes);
    } finally {
      key.destroy();
      keyCopy.fillRange(0, keyCopy.length, 0);
    }
  }

  static Future<List<int>> _derive(String pin, List<int> salt) =>
      Isolate.run(() async {
        final password = SecretKey(utf8.encode(pin));
        SecretKey? derived;
        try {
          derived = await Argon2id(
            memory: 19456,
            iterations: 2,
            parallelism: 1,
            hashLength: 32,
          ).deriveKey(secretKey: password, nonce: salt);
          return List<int>.from(await derived.extractBytes());
        } finally {
          password.destroy();
          derived?.destroy();
        }
      });
}
