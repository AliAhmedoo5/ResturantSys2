@TestOn('windows')
library;

import 'dart:io';

import 'package:pos_data/pos_data.dart';
import 'package:pos_domain/access_policy.dart';
import 'package:pos_domain/command_environment.dart';
import 'package:pos_security/installation_key_store.dart';
import 'package:test/test.dart';

final class AuthClock implements CommandClock {
  DateTime time = DateTime.utc(2026, 10, 16);
  @override
  DateTime nowUtc() => time;
}

final class CollidingIds implements RecordIdSource {
  @override
  String nextId() => 'collision';
}

void main() {
  late Directory root;
  late File file;
  late PosDatabase db;
  late LoadedInstallationKey key;
  late AuthClock clock;
  late AuthenticationService auth;
  AuthenticationService service({
    String terminal = 'fixture-terminal',
    RecordIdSource? ids,
  }) => AuthenticationService(
    database: db,
    key: key,
    terminalId: terminal,
    clock: clock,
    ids: ids,
  );
  setUp(() async {
    root = await Directory.systemTemp.createTemp('cartel-auth-');
    file = File('${root.path}/pos.db');
    db = await PosDatabase.open(file);
    final prepared = await PreparedInstallationKey.create();
    final store = InstallationKeyStore(root);
    await store.initialize(prepared);
    key = await store.load(expectedKeyId: prepared.keyId);
    clock = AuthClock();
    auth = service();
  });
  tearDown(() async {
    await db.close();
    key.dispose();
    await root.delete(recursive: true);
  });
  Future<SetupReceipt> setup({
    AuthenticationService? using,
    String intent = 'first-setup',
    String manager = '724915',
    String cashier = '0638',
    bool acknowledged = true,
    String? confirmation,
    String managerName = 'Fixture Manager',
  }) => (using ?? auth).initialize(
    intentKey: intent,
    managerName: managerName,
    managerPin: manager,
    managerConfirmation: confirmation ?? manager,
    cashierName: 'Fixture Cashier',
    cashierPin: cashier,
    cashierConfirmation: cashier,
    recoveryAcknowledged: acknowledged,
  );
  Future<int> count(String table) async =>
      (await db.customSelect('SELECT COUNT(*) AS n FROM $table').getSingle())
          .read<int>('n');

  test(
    'onboarding atomically persists distinct roles, key binding and one audit event',
    () async {
      final receipt = await setup();
      expect(receipt.managerId, isNot(receipt.cashierId));
      final rows = await db
          .customSelect('SELECT * FROM staff_credentials ORDER BY role')
          .get();
      expect(rows.map((r) => r.read<String>('role')), ['cashier', 'manager']);
      expect(rows.every((r) => r.read<int>('enabled') == 1), true);
      expect(await count('auth_sessions'), 0);
      expect(await count('security_events'), 1);
      final stored = (await db
          .customSelect('SELECT * FROM installation_security')
          .getSingle());
      expect(stored.read<String>('key_id'), key.keyId);
      for (final row in rows) {
        expect(row.read<String>('hash_base64'), isNot(anyOf('724915', '0638')));
        expect(row.data.keys, isNot(contains('pin')));
      }
      await db.close();
      db = await PosDatabase.open(file);
      auth = service();
      final retry = await setup();
      expect(retry.managerId, receipt.managerId);
      expect(await count('staff_credentials'), 2);
      expect(await count('security_events'), 1);
    },
  );

  test(
    'mandatory recovery, exact primary PIN, confirmation and uniqueness precede writes',
    () async {
      await expectLater(setup(acknowledged: false), throwsStateError);
      await expectLater(setup(cashier: '12345'), throwsArgumentError);
      await expectLater(setup(confirmation: 'different'), throwsArgumentError);
      await expectLater(setup(manager: '0638'), throwsA(isA<DuplicatePin>()));
      expect(await count('staff_credentials'), 0);
      expect(await count('installation_security'), 0);
    },
  );

  test('setup retry conflicts cannot replace accounts', () async {
    final original = await setup();
    await expectLater(
      setup(intent: 'other'),
      throwsA(isA<OnboardingConflict>()),
    );
    await expectLater(
      setup(managerName: 'Changed public name'),
      throwsA(isA<OnboardingConflict>()),
    );
    final retry = await setup(
      manager: 'not-tested',
      confirmation: 'not-tested-either',
      cashier: 'not-tested',
    );
    expect(retry.managerId, original.managerId);
    expect(await count('auth_sessions'), 0);
    expect(await count('auth_attempt_limits'), 0);
    expect(
      (await auth.signIn(staffId: original.managerId, pin: '724915')).staff.id,
      original.managerId,
    );
    expect(await count('staff_credentials'), 2);
  });

  test('concurrent setup retries create only one account pair', () async {
    final receipts = await Future.wait([setup(), setup(using: service())]);
    expect(receipts.first.managerId, receipts.last.managerId);
    expect(await count('staff_credentials'), 2);
    expect(await count('security_events'), 1);
  });

  test(
    'onboarding insert failure leaves no partial credential or installation',
    () async {
      await expectLater(
        setup(using: service(ids: CollidingIds())),
        throwsA(anything),
      );
      expect(await count('staff_credentials'), 0);
      expect(await count('installation_security'), 0);
      expect(await count('security_events'), 0);
    },
  );

  test(
    'real PIN verification persists hashed sessions and enforces both roles',
    () async {
      final receipt = await setup();
      final manager = await auth.signIn(
        staffId: receipt.managerId,
        pin: '724915',
      );
      final cashier = await auth.signIn(
        staffId: receipt.cashierId,
        pin: '0638',
      );
      expect(
        (await auth.authorize(
          manager.token,
          Capability.manageBusinessDay,
        )).role,
        StaffRole.manager,
      );
      expect(
        (await auth.authorize(cashier.token, Capability.confirmCheckout)).role,
        StaffRole.cashier,
      );
      await expectLater(
        auth.authorize(manager.token, Capability.confirmCheckout),
        throwsA(isA<AuthorizationDenied>()),
      );
      await expectLater(
        auth.authorize(cashier.token, Capability.manageCredentials),
        throwsA(isA<AuthorizationDenied>()),
      );
      final rows = await db
          .customSelect('SELECT token_hash FROM auth_sessions')
          .get();
      expect(
        rows.every((r) => r.read<String>('token_hash').length == 64),
        true,
      );
      expect(
        rows.any((r) => r.read<String>('token_hash') == cashier.token),
        false,
      );
      expect(cashier.toString(), isNot(contains(cashier.token)));
    },
  );

  test(
    'database uniqueness covers active credentials and disabled accounts cannot sign in',
    () async {
      final receipt = await setup();
      await expectLater(
        db.customStatement(
          "UPDATE staff_credentials SET pin_fingerprint = (SELECT pin_fingerprint FROM staff_credentials WHERE role = 'manager') WHERE role = 'cashier'",
        ),
        throwsA(anything),
      );
      await db.customStatement(
        "UPDATE staff_credentials SET enabled = 0 WHERE role = 'cashier'",
      );
      await db.customStatement(
        "UPDATE staff_credentials SET pin_fingerprint = (SELECT pin_fingerprint FROM staff_credentials WHERE role = 'manager') WHERE role = 'cashier'",
      );
      await expectLater(
        auth.signIn(staffId: receipt.cashierId, pin: '0638'),
        throwsA(isA<AuthenticationRejected>()),
      );
      expect(await count('auth_sessions'), 0);
    },
  );

  test('malformed PIN attempts are rejected generically and charged', () async {
    final receipt = await setup();
    await expectLater(
      auth.signIn(staffId: receipt.cashierId, pin: 'not-a-pin'),
      throwsA(isA<AuthenticationRejected>()),
    );
    expect(
      (await db
              .customSelect('SELECT reserved_count FROM auth_attempt_limits')
              .get())
          .every((r) => r.read<int>('reserved_count') == 1),
      true,
    );
  });

  test(
    'absolute lifetime expires even when the session was recently active',
    () async {
      final receipt = await setup();
      final session = await auth.signIn(
        staffId: receipt.cashierId,
        pin: '0638',
      );
      clock.time = clock.time.add(AuthenticationService.maximumSessionLifetime);
      await db.customStatement('UPDATE auth_sessions SET last_seen_ms = ?', [
        clock.time.subtract(const Duration(seconds: 1)).millisecondsSinceEpoch,
      ]);
      await expectLater(
        auth.authorize(session.token, Capability.confirmCheckout),
        throwsA(isA<AuthenticationRejected>()),
      );
    },
  );

  test(
    'five wrong attempts persist across reopen and block correct PIN until cooldown',
    () async {
      final receipt = await setup();
      for (var i = 0; i < 5; i++) {
        await expectLater(
          auth.signIn(staffId: receipt.cashierId, pin: '7777'),
          throwsA(isA<AuthenticationRejected>()),
        );
      }
      await db.close();
      db = await PosDatabase.open(file);
      auth = service();
      await expectLater(
        auth.signIn(staffId: receipt.cashierId, pin: '0638'),
        throwsA(isA<AuthenticationThrottled>()),
      );
      expect(await count('auth_sessions'), 0);
      clock.time = clock.time.add(AuthenticationService.attemptWindow);
      expect(
        (await auth.signIn(staffId: receipt.cashierId, pin: '0638')).staff.id,
        receipt.cashierId,
      );
    },
  );

  test(
    'unknown account guesses share device budget without unbounded counter rows',
    () async {
      final receipt = await setup();
      for (var i = 0; i < AuthenticationService.deviceAttemptLimit; i++) {
        await expectLater(
          auth.signIn(staffId: 'unknown-$i', pin: '7777'),
          throwsA(isA<AuthenticationRejected>()),
        );
      }
      expect(await count('auth_attempt_limits'), 1);
      await expectLater(
        auth.signIn(staffId: receipt.managerId, pin: '724915'),
        throwsA(isA<AuthenticationThrottled>()),
      );
    },
  );

  test(
    'success releases only its own reservation and does not clear prior failures',
    () async {
      final receipt = await setup();
      for (var i = 0; i < 3; i++) {
        await expectLater(
          auth.signIn(staffId: receipt.cashierId, pin: '7777'),
          throwsA(isA<AuthenticationRejected>()),
        );
      }
      await auth.signIn(staffId: receipt.cashierId, pin: '0638');
      final counts = await db
          .customSelect('SELECT reserved_count FROM auth_attempt_limits')
          .get();
      expect(counts.every((row) => row.read<int>('reserved_count') == 3), true);
    },
  );

  test('concurrent guesses cannot exceed account budget', () async {
    final receipt = await setup();
    final results = await Future.wait(
      List.generate(8, (_) async {
        try {
          await service().signIn(staffId: receipt.cashierId, pin: '7777');
          return 'unexpected';
        } on AuthenticationRejected {
          return 'rejected';
        } on AuthenticationThrottled {
          return 'throttled';
        }
      }),
    );
    expect(results.where((r) => r == 'rejected').length, 5);
    expect(results.where((r) => r == 'throttled').length, 3);
    expect(await count('auth_sessions'), 0);
  });

  test(
    'login cannot hide its attempt budget inside a caller rollback',
    () async {
      final receipt = await setup();
      await expectLater(
        db.transaction(
          () => auth.signIn(staffId: receipt.cashierId, pin: '0638'),
        ),
        throwsStateError,
      );
      expect(await count('auth_attempt_limits'), 0);
    },
  );

  test(
    'process exit after reservation retains attempt budget without issuing a session',
    () async {
      await setup();
      final helper = Platform.environment['POS_WRITER_TEST_HELPER'];
      if (helper == null) throw StateError('Hosted test helper is required.');
      await db.close();
      final child = await Process.run(helper, [
        file.path,
        'auth-after-reservation',
      ]);
      expect(child.exitCode, 79, reason: '${child.stderr}');
      db = await PosDatabase.open(file);
      auth = service();
      expect(await count('auth_sessions'), 0);
      final counts = await db
          .customSelect('SELECT reserved_count FROM auth_attempt_limits')
          .get();
      expect(counts, hasLength(2));
      expect(counts.every((r) => r.read<int>('reserved_count') == 1), true);
      expect(await count('security_events'), 2);
    },
  );

  test(
    'audit failure rolls back session and leaves committed attempt charged',
    () async {
      final receipt = await setup();
      await expectLater(
        service(
          ids: CollidingIds(),
        ).signIn(staffId: receipt.cashierId, pin: '0638'),
        throwsA(anything),
      );
      expect(await count('auth_sessions'), 0);
      expect(
        (await db
                .customSelect('SELECT reserved_count FROM auth_attempt_limits')
                .get())
            .every((r) => r.read<int>('reserved_count') == 1),
        true,
      );
    },
  );

  test(
    'terminal and installation key mismatches refuse authentication',
    () async {
      final receipt = await setup();
      await expectLater(
        service(
          terminal: 'other',
        ).signIn(staffId: receipt.cashierId, pin: '0638'),
        throwsA(isA<AuthenticationRejected>()),
      );
      final otherDir = await Directory('${root.path}/other-key').create();
      final prepared = await PreparedInstallationKey.create();
      final store = InstallationKeyStore(otherDir);
      await store.initialize(prepared);
      final otherKey = await store.load(expectedKeyId: prepared.keyId);
      try {
        final wrong = AuthenticationService(
          database: db,
          key: otherKey,
          terminalId: 'fixture-terminal',
          clock: clock,
        );
        await expectLater(
          wrong.signIn(staffId: receipt.cashierId, pin: '0638'),
          throwsA(isA<AuthenticationRejected>()),
        );
      } finally {
        otherKey.dispose();
      }
    },
  );

  test(
    'idle expiry, clock rollback and explicit lock refuse session reuse',
    () async {
      final receipt = await setup();
      final session = await auth.signIn(
        staffId: receipt.cashierId,
        pin: '0638',
      );
      clock.time = clock.time.subtract(const Duration(seconds: 1));
      await expectLater(
        auth.authorize(session.token, Capability.confirmCheckout),
        throwsA(isA<AuthenticationRejected>()),
      );
      await expectLater(
        auth.signIn(staffId: receipt.cashierId, pin: '0638'),
        throwsA(isA<AuthenticationThrottled>()),
      );
      clock.time = clock.time.add(const Duration(seconds: 1));
      await auth.lockSession(session.token);
      await expectLater(
        auth.authorize(session.token, Capability.confirmCheckout),
        throwsA(isA<AuthenticationRejected>()),
      );
      final next = await auth.signIn(staffId: receipt.cashierId, pin: '0638');
      clock.time = clock.time.add(AuthenticationService.idleTimeout);
      await expectLater(
        auth.authorize(next.token, Capability.confirmCheckout),
        throwsA(isA<AuthenticationRejected>()),
      );
    },
  );

  for (final change in [
    "enabled = 0",
    "revision = revision + 1",
    "role = 'manager'",
  ]) {
    test('current staff state invalidates session: $change', () async {
      final receipt = await setup();
      final session = await auth.signIn(
        staffId: receipt.cashierId,
        pin: '0638',
      );
      // Fixture mutation stands in for forthcoming audited Manager commands.
      await db.customStatement(
        'UPDATE staff_credentials SET $change WHERE id = ?',
        [receipt.cashierId],
      );
      await expectLater(
        auth.authorize(session.token, Capability.confirmCheckout),
        throwsA(isA<AuthenticationRejected>()),
      );
    });
  }

  test('security history rejects updates deletes and replacement', () async {
    await setup();
    final row = await db
        .customSelect('SELECT * FROM security_events')
        .getSingle();
    for (final sql in [
      'DELETE FROM security_events',
      "UPDATE security_events SET kind = 'login_failed'",
      'INSERT OR REPLACE INTO security_events SELECT * FROM security_events',
    ]) {
      await expectLater(db.customStatement(sql), throwsA(anything));
    }
    expect(
      (await db.customSelect('SELECT * FROM security_events').getSingle()).data,
      row.data,
    );
  });

  test(
    'coordinator binds audit actor and session to live authorization including replay',
    () async {
      final receipt = await setup();
      final session = await auth.signIn(
        staffId: receipt.cashierId,
        pin: '0638',
      );
      final coordinator = CommandCoordinator(
        database: db,
        clock: clock,
        ids: SecureRecordIdSource(),
        terminalId: 'fixture-terminal',
        appVersion: 'test',
      );
      CommandIntent intent(String actor) => CommandIntent(
        key: 'probe-command',
        kind: 'test.auth',
        actorId: actor,
        sessionId: session.id,
        entityType: 'probe',
        entityId: 'probe',
        expectedRevision: 0,
        reason: 'fixture',
        payload: {},
      );
      Future<CommandReceipt> execute(CommandIntent command) =>
          coordinator.execute(
            command,
            authorize: () => auth.authorizeCommand(
              session.token,
              command,
              Capability.confirmCheckout,
            ),
            apply: () async => CommandChange(
              result: {'accepted': true},
              before: {},
              after: {},
            ),
          );
      await expectLater(
        execute(intent(receipt.managerId)),
        throwsA(isA<AuthenticationRejected>()),
      );
      expect(await count('audit_events'), 0);
      final command = intent(receipt.cashierId);
      expect((await execute(command)).replayed, false);
      expect((await execute(command)).replayed, true);
      await auth.lockSession(session.token);
      await expectLater(
        execute(command),
        throwsA(isA<AuthenticationRejected>()),
      );
      expect(await count('audit_events'), 1);
    },
  );
}
