import 'dart:convert';
import 'dart:io';

import 'package:pos_data/pos_data.dart';
import 'package:pos_domain/command_environment.dart';
import 'package:pos_security/installation_key_store.dart';

final class ExitAfterReservationClock implements CommandClock {
  int calls = 0;
  @override
  DateTime nowUtc() {
    if (++calls == 2) exit(79);
    return DateTime.utc(2026, 10, 16);
  }
}

Future<void> main(List<String> arguments) async {
  try {
    final database = await PosDatabase.open(File(arguments.first));
    if (arguments.length == 2 && arguments[1] == 'auth-after-reservation') {
      final installation = await database
          .customSelect('SELECT * FROM installation_security')
          .getSingle();
      final key = await InstallationKeyStore(
        File(arguments.first).parent,
      ).load(expectedKeyId: installation.read<String>('key_id'));
      final auth = AuthenticationService(
        database: database,
        key: key,
        terminalId: installation.read<String>('terminal_id'),
        clock: ExitAfterReservationClock(),
      );
      await auth.signIn(
        staffId: installation.read<String>('primary_cashier_id'),
        pin: '7777',
      );
      throw StateError('Crash fixture did not exit at the intended boundary.');
    }
    if (arguments.length == 2) {
      final coordinator = CommandCoordinator(
        database: database,
        clock: const SystemCommandClock(),
        ids: SecureRecordIdSource(),
        terminalId: 'test',
        appVersion: 'test',
      );
      await coordinator.execute(
        CommandIntent(
          key: 'command-1',
          kind: 'test.write',
          actorId: 'cashier-test',
          sessionId: 'session-test',
          entityType: 'probe',
          entityId: 'probe-1',
          expectedRevision: 0,
          reason: 'Synthetic test only',
          payload: {'value': 7},
        ),
        authorize: () async {},
        apply: () async {
          await database.customStatement('INSERT INTO probe VALUES (7)');
          if (arguments[1] == 'before-commit') exit(77);
          return CommandChange(
            result: {'saved': 7},
            before: {},
            after: {'value': 7},
          );
        },
      );
      // No response delivery and no graceful database close after commit.
      exit(78);
    }
    stdout.writeln('\nREADY');
    await stdout.flush();
    final command = await stdin
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .first;
    if (command == 'crash') {
      // Intentionally bypasses close/finally, exercising OS crash lock release.
      exit(0);
    }
    await database.close();
  } on DatabaseAlreadyOpenException {
    stdout.writeln('ALREADY_OPEN');
    exitCode = 23;
  }
}
