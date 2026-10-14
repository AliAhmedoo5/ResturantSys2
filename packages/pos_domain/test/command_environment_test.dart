import 'package:pos_domain/command_environment.dart';

// Dependency-free executable checks; failures remain active without assertions.
void main() {
  const system = SystemCommandClock();
  final before = DateTime.now().toUtc();
  final observed = system.nowUtc();
  final after = DateTime.now().toUtc();
  if (!observed.isUtc || observed.isBefore(before) || observed.isAfter(after)) {
    throw StateError('System clock must return the current UTC instant.');
  }

  // Commands can receive controlled dependencies without UI or storage imports.
  final fixed = DateTime.utc(2026, 10, 14, 23, 59, 59);
  final CommandClock clock = _FixedClock(fixed);
  final RecordIdSource ids = _SequenceIds();
  if (clock.nowUtc() != fixed || clock.nowUtc() != fixed) {
    throw StateError('Injected clock is not deterministic.');
  }
  if (ids.nextId() != 'record-0' || ids.nextId() != 'record-1') {
    throw StateError('Injected identifiers are not deterministic.');
  }

  final format = RegExp(r'^[0-9a-f]{32}$');
  final sources = [SecureRecordIdSource(), SecureRecordIdSource()];
  final generated = <String>{};
  for (var index = 0; index < 4096; index++) {
    final id = sources[index % sources.length].nextId();
    if (!format.hasMatch(id) || !generated.add(id)) {
      throw StateError('Invalid or repeated record identifier.');
    }
  }
  // Sampling catches wiring errors; it is not proof of collision impossibility.
  print('Passed UTC clock, injected dependencies and record ID smoke checks.');
}

final class _FixedClock implements CommandClock {
  const _FixedClock(this.value);

  final DateTime value;

  @override
  DateTime nowUtc() => value;
}

final class _SequenceIds implements RecordIdSource {
  int _next = 0;

  @override
  String nextId() => 'record-${_next++}';
}
