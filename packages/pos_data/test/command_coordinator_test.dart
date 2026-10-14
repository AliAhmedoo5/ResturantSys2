@TestOn('windows')
library;

import 'dart:io';

import 'package:pos_data/pos_data.dart';
import 'package:pos_domain/command_environment.dart';
import 'package:test/test.dart';

final class TestClock implements CommandClock {
  DateTime time = DateTime.utc(2026, 10, 14);
  @override
  DateTime nowUtc() => time;
}

final class TestIds implements RecordIdSource {
  int next = 0;
  @override
  String nextId() => 'audit-${next++}';
}

void main() {
  late Directory root;
  late File file;
  late PosDatabase db;
  late TestClock clock;
  late TestIds ids;
  late CommandCoordinator coordinator;
  CommandCoordinator createCoordinator() => CommandCoordinator(
    database: db,
    clock: clock,
    ids: ids,
    terminalId: 'test-terminal',
    appVersion: 'test',
  );
  setUp(() async {
    root = await Directory.systemTemp.createTemp('cartel-commands-');
    file = File('${root.path}/pos.db');
    db = await PosDatabase.open(file);
    await db.customStatement('CREATE TABLE probe (value INTEGER NOT NULL)');
    clock = TestClock();
    ids = TestIds();
    coordinator = createCoordinator();
  });
  tearDown(() async {
    await db.close();
    await root.delete(recursive: true);
  });

  CommandIntent intent({
    String key = 'command-1',
    int revision = 0,
    String actor = 'cashier-test',
    String session = 'session-test',
    Map<String, Object?> payload = const {'value': 7},
  }) => CommandIntent(
    key: key,
    kind: 'test.write',
    actorId: actor,
    sessionId: session,
    entityType: 'probe',
    entityId: 'probe-1',
    expectedRevision: revision,
    reason: 'Synthetic test only',
    payload: payload,
  );
  Future<void> authorized() async {}
  Future<CommandChange> apply() async {
    await db.customStatement('INSERT INTO probe VALUES (7)');
    return CommandChange(result: {'saved': 7}, before: {}, after: {'value': 7});
  }

  Future<int> count(String table) async =>
      (await db.customSelect('SELECT COUNT(*) AS n FROM $table').getSingle())
          .read<int>('n');
  Future<void> empty() async {
    for (final table in [
      'probe',
      'audit_events',
      'idempotency_commands',
      'command_versions',
    ]) {
      expect(await count(table), 0, reason: table);
    }
  }

  test(
    'atomic result, nullable approver and audit survive reopen and retry',
    () async {
      final receipt = await coordinator.execute(
        intent(),
        authorize: authorized,
        apply: apply,
      );
      expect(receipt.replayed, isFalse);
      final audit = await db
          .customSelect('SELECT * FROM audit_events')
          .getSingle();
      expect(
        audit.read<String>('created_at_utc'),
        clock.time.toIso8601String(),
      );
      expect(audit.data['approver_id'], isNull);
      expect(audit.read<String>('actor_id'), 'cashier-test');
      await db.close();
      db = await PosDatabase.open(file);
      coordinator = createCoordinator();
      final retry = await coordinator.execute(
        intent(session: 'new-session'),
        authorize: authorized,
        apply: () async => throw StateError('Must not apply again'),
      );
      expect(retry.replayed, isTrue);
      expect(retry.resultJson, receipt.resultJson);
      for (final table in ['probe', 'audit_events', 'idempotency_commands']) {
        expect(await count(table), 1);
      }
    },
  );

  test(
    'map key order is irrelevant and input mutation cannot change saved intent',
    () async {
      final payload = <String, Object?>{
        'b': [1, 2],
        'a': 7,
      };
      final original = intent(payload: payload);
      payload['a'] = 99;
      await coordinator.execute(original, authorize: authorized, apply: apply);
      final retry = await coordinator.execute(
        intent(
          payload: {
            'a': 7,
            'b': [1, 2],
          },
        ),
        authorize: authorized,
        apply: apply,
      );
      expect(retry.replayed, isTrue);
      expect(await count('probe'), 1);
    },
  );

  test('changed payload or actor cannot reuse a committed key', () async {
    await coordinator.execute(intent(), authorize: authorized, apply: apply);
    for (final changed in [
      intent(payload: {'value': 8}),
      intent(actor: 'other'),
    ]) {
      await expectLater(
        coordinator.execute(changed, authorize: authorized, apply: apply),
        throwsA(isA<CommandConflict>()),
      );
    }
    expect(await count('probe'), 1);
  });

  test('authorization is required again on replay', () async {
    await coordinator.execute(intent(), authorize: authorized, apply: apply);
    await expectLater(
      coordinator.execute(
        intent(),
        authorize: () async => throw StateError('Session revoked'),
        apply: apply,
      ),
      throwsStateError,
    );
    expect(await count('probe'), 1);
  });

  test(
    'failed apply rolls back all writes and permits the same key to retry',
    () async {
      await expectLater(
        coordinator.execute(
          intent(),
          authorize: authorized,
          apply: () async {
            await apply();
            throw StateError('Injected posting failure');
          },
        ),
        throwsStateError,
      );
      await empty();
      expect(
        (await coordinator.execute(
          intent(),
          authorize: authorized,
          apply: apply,
        )).replayed,
        isFalse,
      );
    },
  );

  test('audit failure rolls back business writes and saved result', () async {
    await coordinator.execute(intent(), authorize: authorized, apply: apply);
    ids.next =
        0; // Force a collision after the business write and command insert.
    await expectLater(
      coordinator.execute(
        intent(key: 'command-2', revision: 1),
        authorize: authorized,
        apply: apply,
      ),
      throwsA(anything),
    );
    expect(await count('probe'), 1);
    expect(await count('idempotency_commands'), 1);
    final version = await db
        .customSelect('SELECT revision FROM command_versions')
        .getSingle();
    expect(version.read<int>('revision'), 1);
  });

  test(
    'concurrent identical calls commit once across coordinator instances',
    () async {
      final receipts = await Future.wait([
        coordinator.execute(intent(), authorize: authorized, apply: apply),
        createCoordinator().execute(
          intent(),
          authorize: authorized,
          apply: apply,
        ),
      ]);
      expect(receipts.where((r) => r.replayed).length, 1);
      expect(await count('probe'), 1);
    },
  );

  test('stale revision fails and current revision advances once', () async {
    await coordinator.execute(intent(), authorize: authorized, apply: apply);
    await expectLater(
      coordinator.execute(
        intent(key: 'stale'),
        authorize: authorized,
        apply: apply,
      ),
      throwsA(isA<StaleCommandRevision>()),
    );
    await coordinator.execute(
      intent(key: 'next', revision: 1),
      authorize: authorized,
      apply: apply,
    );
    expect(
      (await db
              .customSelect('SELECT revision FROM command_versions')
              .getSingle())
          .read<int>('revision'),
      2,
    );
  });

  test(
    'two different commands racing the same revision have one winner',
    () async {
      Future<bool> run(String key) async {
        try {
          await coordinator.execute(
            intent(key: key),
            authorize: authorized,
            apply: apply,
          );
          return true;
        } on StaleCommandRevision {
          return false;
        }
      }

      expect(
        (await Future.wait([run('a'), run('b')])).where((v) => v).length,
        1,
      );
      expect(await count('probe'), 1);
    },
  );

  test(
    'update, delete and replace cannot change audit or command history',
    () async {
      await coordinator.execute(intent(), authorize: authorized, apply: apply);
      for (final sql in [
        "UPDATE audit_events SET reason = 'tamper'",
        'DELETE FROM audit_events',
        "UPDATE idempotency_commands SET result_json = '{}'",
        'DELETE FROM idempotency_commands',
        'INSERT OR REPLACE INTO audit_events SELECT * FROM audit_events',
        'INSERT OR REPLACE INTO idempotency_commands SELECT * FROM idempotency_commands',
      ]) {
        await expectLater(db.customStatement(sql), throwsA(anything));
      }
      expect(await count('audit_events'), 1);
      expect(await count('idempotency_commands'), 1);
    },
  );

  test(
    'nested command or outer transaction cannot report a premature commit',
    () async {
      await expectLater(
        db.transaction(
          () => coordinator.execute(
            intent(),
            authorize: authorized,
            apply: apply,
          ),
        ),
        throwsStateError,
      );
      await expectLater(
        coordinator.execute(
          intent(),
          authorize: authorized,
          apply: () async {
            await coordinator.execute(
              intent(key: 'nested'),
              authorize: authorized,
              apply: apply,
            );
            return apply();
          },
        ),
        throwsStateError,
      );
      await empty();
    },
  );

  test('invalid UTC clock rolls back without posting', () async {
    clock.time = DateTime(2026, 10, 14);
    await expectLater(
      coordinator.execute(intent(), authorize: authorized, apply: apply),
      throwsStateError,
    );
    await empty();
  });

  test('invalid revision and floating point payloads are rejected', () {
    expect(() => intent(revision: -1), throwsArgumentError);
    expect(() => intent(revision: 9223372036854775807), throwsArgumentError);
    expect(() => intent(payload: {'amount': 1.5}), throwsArgumentError);
    expect(() => intent(key: ''), throwsArgumentError);
  });

  for (final phase in ['before-commit', 'after-commit']) {
    test('process exit $phase leaves a safely retryable command', () async {
      final helper = Platform.environment['POS_WRITER_TEST_HELPER'];
      if (helper == null) throw StateError('Hosted test helper is required.');
      await db.close();
      final child = await Process.run(helper, [file.path, phase]);
      expect(
        child.exitCode,
        phase == 'before-commit' ? 77 : 78,
        reason: '${child.stderr}',
      );
      db = await PosDatabase.open(file);
      coordinator = createCoordinator();
      expect(await count('probe'), phase == 'before-commit' ? 0 : 1);
      final retry = await coordinator.execute(
        intent(),
        authorize: authorized,
        apply: apply,
      );
      expect(retry.replayed, phase == 'after-commit');
      for (final table in ['probe', 'idempotency_commands', 'audit_events']) {
        expect(await count(table), 1);
      }
    });
  }
}
