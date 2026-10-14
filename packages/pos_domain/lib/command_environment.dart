import 'dart:math';

/// Inject into command services so audit timestamps can be tested deterministically.
/// Wall time is evidence, never a sequence, lock, or business-day identifier.
abstract interface class CommandClock {
  DateTime nowUtc();
}

final class SystemCommandClock implements CommandClock {
  const SystemCommandClock();

  @override
  DateTime nowUtc() => DateTime.now().toUtc();
}

/// Generates opaque record identifiers, not customer-facing order tokens.
/// A retry must reuse its original command ID, not request a new one.
abstract interface class RecordIdSource {
  String nextId();
}

/// 128 random bits, encoded as 32 lowercase hexadecimal characters.
/// Storage must still enforce uniqueness. Secure entropy failure propagates;
/// there is no timestamp, counter, or weak-random fallback.
final class SecureRecordIdSource implements RecordIdSource {
  SecureRecordIdSource() : _random = Random.secure();

  final Random _random;

  @override
  String nextId() {
    final result = StringBuffer();
    for (var index = 0; index < 16; index++) {
      result.write(_random.nextInt(256).toRadixString(16).padLeft(2, '0'));
    }
    return result.toString();
  }
}
