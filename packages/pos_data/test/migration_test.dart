@TestOn('windows')
library;

import 'dart:io';

import 'package:pos_data/pos_data.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';

// Frozen v1 fixture: never generate it from the current Drift schema.
void createV1(File file) {
  final old = sqlite3.open(file.path);
  try {
    old.execute('''
      CREATE TABLE database_metadata (
        singleton INTEGER NOT NULL PRIMARY KEY CHECK (singleton = 1),
        format_tag TEXT NOT NULL CHECK (format_tag = 'crunch-cartel')
      );
      INSERT INTO database_metadata VALUES (1, 'crunch-cartel');
      CREATE TABLE preservation_probe (
        id INTEGER PRIMARY KEY,
        amount_paisa INTEGER NOT NULL,
        note TEXT NOT NULL
      );
      INSERT INTO preservation_probe VALUES (1, 61625, 'keep original');
      INSERT INTO preservation_probe VALUES (2, -20000, 'keep signed amount');
      PRAGMA user_version = 1;
    ''');
    // Use the established application constant, not the current schema version.
    old.execute('PRAGMA application_id = ${PosDatabase.applicationId}');
  } finally {
    old.close();
  }
}

int version(File file) {
  final raw = sqlite3.open(file.path, mode: OpenMode.readOnly);
  try {
    return raw.select('PRAGMA user_version').single.values.single as int;
  } finally {
    raw.close();
  }
}

// Frozen v2 history definition; do not derive from current generated tables.
void createV2(File file) {
  createV1(file);
  final old = sqlite3.open(file.path);
  try {
    old.execute('''
      CREATE TABLE schema_upgrades (
        to_version INTEGER NOT NULL PRIMARY KEY CHECK (to_version >= 2),
        from_version INTEGER NOT NULL CHECK (from_version >= 1 AND from_version < to_version),
        applied_at_utc TEXT NOT NULL,
        app_version TEXT NOT NULL,
        backup_directory TEXT NOT NULL,
        backup_sha256 TEXT NOT NULL CHECK (length(backup_sha256) = 64)
      );
      PRAGMA user_version = 2;
    ''');
    old.execute('INSERT INTO schema_upgrades VALUES (?, ?, ?, ?, ?, ?)', [
      2,
      1,
      '2026-10-14T00:00:00.000Z',
      'old-test',
      'synthetic-old-backup',
      'a' * 64,
    ]);
  } finally {
    old.close();
  }
}

// Exact committed v3 SQL fixture, not regenerated from the current schema.
void createV3(File file) {
  final old = sqlite3.open(file.path);
  try {
    old.execute(File('test/fixtures/schema_v3.sql').readAsStringSync());
    old.execute("INSERT INTO database_metadata VALUES (1, 'crunch-cartel')");
    old.execute('PRAGMA application_id = ${PosDatabase.applicationId}');
    old.execute('PRAGMA user_version = 3');
    old.execute('INSERT INTO idempotency_commands VALUES (?, ?, ?, ?, ?)', [
      'old-command',
      'fixture',
      'a' * 64,
      '{"saved":true}',
      '2026-10-14T00:00:00.000Z',
    ]);
  } finally {
    old.close();
  }
}

void main() {
  late Directory root;
  late Directory backups;
  late File file;
  setUp(() async {
    root = await Directory.systemTemp.createTemp('cartel-migration-test-');
    backups = await Directory('${root.path}/backups').create();
    file = File('${root.path}/pos.db');
  });
  tearDown(() async => root.delete(recursive: true));

  MigrationBackup policy() =>
      MigrationBackup(directory: backups, appVersion: 'migration-test');

  test(
    'v1 upgrade preserves rows and records a verified source-version backup',
    () async {
      createV1(file);
      final walWriter = sqlite3.open(file.path);
      final PosDatabase db;
      try {
        walWriter.execute('PRAGMA journal_mode = WAL');
        walWriter.execute('PRAGMA wal_autocheckpoint = 0');
        walWriter.execute(
          "INSERT INTO preservation_probe VALUES (3, 100, 'committed in WAL')",
        );
        expect(await File('${file.path}-wal').length(), greaterThan(0));
        db = await PosDatabase.open(file, migrationBackup: policy());
      } finally {
        walWriter.close();
      }
      try {
        expect(
          (await db.customSelect('PRAGMA user_version').getSingle())
              .data
              .values
              .single,
          PosDatabase.currentSchemaVersion,
        );
        final rows = await db
            .customSelect('SELECT * FROM preservation_probe ORDER BY id')
            .get();
        expect(rows.map((row) => row.read<int>('amount_paisa')), [
          61625,
          -20000,
          100,
        ]);
        expect(rows.map((row) => row.read<String>('note')), [
          'keep original',
          'keep signed amount',
          'committed in WAL',
        ]);
        final entry = await db
            .customSelect('SELECT * FROM schema_upgrades')
            .getSingle();
        expect(entry.read<int>('from_version'), 1);
        expect(entry.read<int>('to_version'), PosDatabase.currentSchemaVersion);
        expect(
          DateTime.parse(entry.read<String>('applied_at_utc')).isUtc,
          isTrue,
        );
        final snapshot = await PosDatabase.verifySnapshot(
          Directory(entry.read<String>('backup_directory')),
        );
        expect(snapshot.schemaVersion, 1);
        expect(snapshot.sha256Hex, entry.read<String>('backup_sha256'));
        final copy = sqlite3.open(
          snapshot.databaseFile.path,
          mode: OpenMode.readOnly,
        );
        try {
          expect(
            copy
                .select(
                  'SELECT sum(amount_paisa) AS total FROM preservation_probe',
                )
                .single['total'],
            41725,
          );
          expect(
            copy.select(
              "SELECT name FROM sqlite_master WHERE name = 'schema_upgrades'",
            ),
            isEmpty,
          );
        } finally {
          copy.close();
        }
      } finally {
        await db.close();
      }
      final reopened = await PosDatabase.open(file);
      await reopened.close();
      expect(await backups.list().length, 1);
    },
  );

  test(
    'v1 without backup policy fails closed and releases ownership for retry',
    () async {
      createV1(file);
      await expectLater(
        PosDatabase.open(file),
        throwsA(isA<MigrationBackupRequiredException>()),
      );
      expect(version(file), 1);
      expect(await backups.list().toList(), isEmpty);
      final retry = await PosDatabase.open(file, migrationBackup: policy());
      await retry.close();
      expect(version(file), PosDatabase.currentSchemaVersion);
    },
  );

  test(
    'missing backup destination prevents migration without recreating it',
    () async {
      createV1(file);
      final missing = Directory('${root.path}/disconnected');
      await expectLater(
        PosDatabase.open(
          file,
          migrationBackup: MigrationBackup(
            directory: missing,
            appVersion: 'test',
          ),
        ),
        throwsA(anything),
      );
      expect(await missing.exists(), isFalse);
      expect(version(file), 1);
      final retry = await PosDatabase.open(file, migrationBackup: policy());
      await retry.close();
    },
  );

  test('invalid backup metadata prevents every schema change', () async {
    createV1(file);
    await expectLater(
      PosDatabase.open(
        file,
        migrationBackup: MigrationBackup(directory: backups, appVersion: ''),
      ),
      throwsArgumentError,
    );
    expect(version(file), 1);
    expect(await backups.list().toList(), isEmpty);
  });

  test(
    'schema collision rolls back upgrade and retains verified recovery snapshot',
    () async {
      createV1(file);
      final raw = sqlite3.open(file.path);
      raw.execute('CREATE TABLE schema_upgrades (note TEXT)');
      raw.execute("INSERT INTO schema_upgrades VALUES ('do not replace')");
      raw.close();
      DatabaseMigrationException? failure;
      try {
        final unexpected = await PosDatabase.open(
          file,
          migrationBackup: policy(),
        );
        await unexpected.close();
        fail('Conflicting schema must not be overwritten');
      } on DatabaseMigrationException catch (error) {
        failure = error;
      }
      expect(version(file), 1);
      final snapshot = await PosDatabase.verifySnapshot(
        failure.backupDirectory,
      );
      expect(snapshot.schemaVersion, 1);
      final preserved = sqlite3.open(file.path, mode: OpenMode.readOnly);
      try {
        expect(
          preserved.select('SELECT note FROM schema_upgrades').single['note'],
          'do not replace',
        );
        expect(
          preserved
              .select(
                'SELECT sum(amount_paisa) AS total FROM preservation_probe',
              )
              .single['total'],
          41625,
        );
      } finally {
        preserved.close();
      }
    },
  );

  test('invalid v1 identity is refused before creating an archive', () async {
    createV1(file);
    final raw = sqlite3.open(file.path);
    raw.execute('DELETE FROM database_metadata');
    raw.close();
    final original = await file.readAsBytes();
    await expectLater(
      PosDatabase.open(file, migrationBackup: policy()),
      throwsA(anything),
    );
    expect(await file.readAsBytes(), original);
    expect(await backups.list().toList(), isEmpty);
  });

  test('fresh and upgraded databases expose the same history schema', () async {
    createV1(file);
    final upgraded = await PosDatabase.open(file, migrationBackup: policy());
    final fresh = await PosDatabase.open(File('${root.path}/fresh.db'));
    try {
      final oldColumns = await upgraded
          .customSelect('PRAGMA table_info(schema_upgrades)')
          .get();
      final newColumns = await fresh
          .customSelect('PRAGMA table_info(schema_upgrades)')
          .get();
      expect(
        oldColumns.map((row) => row.data),
        newColumns.map((row) => row.data),
      );
      expect(
        await fresh.customSelect('SELECT * FROM schema_upgrades').get(),
        isEmpty,
      );
    } finally {
      await upgraded.close();
      await fresh.close();
    }
  });

  test(
    'current database missing migration history fails without silent repair',
    () async {
      final db = await PosDatabase.open(file);
      await db.customStatement('DROP TABLE schema_upgrades');
      await db.close();
      await expectLater(
        PosDatabase.open(file, migrationBackup: policy()),
        throwsA(anything),
      );
      expect(await backups.list().toList(), isEmpty);
    },
  );

  test(
    'v2 upgrade preserves history and adds empty guarded command tables',
    () async {
      createV2(file);
      final db = await PosDatabase.open(file, migrationBackup: policy());
      final fresh = await PosDatabase.open(File('${root.path}/fresh.db'));
      try {
        final rows = await db
            .customSelect('SELECT * FROM schema_upgrades ORDER BY to_version')
            .get();
        expect(rows.length, 2);
        expect(
          rows.first.read<String>('backup_directory'),
          'synthetic-old-backup',
        );
        expect(rows.last.read<int>('from_version'), 2);
        expect(
          rows.last.read<int>('to_version'),
          PosDatabase.currentSchemaVersion,
        );
        final backup = await PosDatabase.verifySnapshot(
          Directory(rows.last.read<String>('backup_directory')),
        );
        expect(backup.schemaVersion, 2);
        for (final table in [
          'idempotency_commands',
          'command_versions',
          'audit_events',
        ]) {
          expect(await db.customSelect('SELECT * FROM $table').get(), isEmpty);
          expect(
            (await db.customSelect('PRAGMA table_info($table)').get()).map(
              (r) => r.data,
            ),
            (await fresh.customSelect('PRAGMA table_info($table)').get()).map(
              (r) => r.data,
            ),
          );
        }
      } finally {
        await db.close();
        await fresh.close();
      }
    },
  );

  test('v2 requires a verified backup before upgrade', () async {
    createV2(file);
    await expectLater(
      PosDatabase.open(file),
      throwsA(isA<MigrationBackupRequiredException>()),
    );
    expect(version(file), 2);
  });

  test('v2 table collision rolls back and retains recovery archive', () async {
    createV2(file);
    final raw = sqlite3.open(file.path);
    raw.execute('CREATE TABLE audit_events (note TEXT)');
    raw.execute("INSERT INTO audit_events VALUES ('preserve')");
    raw.close();
    await expectLater(
      PosDatabase.open(file, migrationBackup: policy()),
      throwsA(isA<DatabaseMigrationException>()),
    );
    expect(version(file), 2);
    final after = sqlite3.open(file.path, mode: OpenMode.readOnly);
    try {
      expect(
        after.select('SELECT note FROM audit_events').single['note'],
        'preserve',
      );
    } finally {
      after.close();
    }
    expect(await backups.list().length, 1);
  });

  test('missing immutable-history trigger refuses reopening', () async {
    final db = await PosDatabase.open(file);
    await db.customStatement('DROP TRIGGER audit_events_no_update');
    await db.close();
    await expectLater(PosDatabase.open(file), throwsA(anything));
  });

  test(
    'frozen v3 upgrade preserves command results and creates matching authentication schema',
    () async {
      createV3(file);
      final db = await PosDatabase.open(file, migrationBackup: policy());
      final fresh = await PosDatabase.open(File('${root.path}/fresh.db'));
      try {
        expect(
          (await db
                  .customSelect('SELECT result_json FROM idempotency_commands')
                  .getSingle())
              .read<String>('result_json'),
          '{"saved":true}',
        );
        final upgrade = await db
            .customSelect('SELECT * FROM schema_upgrades')
            .getSingle();
        expect(upgrade.read<int>('from_version'), 3);
        expect(
          (await PosDatabase.verifySnapshot(
            Directory(upgrade.read<String>('backup_directory')),
          )).schemaVersion,
          3,
        );
        for (final table in [
          'staff_credentials',
          'installation_security',
          'auth_attempt_limits',
          'auth_sessions',
          'security_events',
        ]) {
          expect(await db.customSelect('SELECT * FROM $table').get(), isEmpty);
          expect(
            (await db.customSelect('PRAGMA table_info($table)').get()).map(
              (r) => r.data,
            ),
            (await fresh.customSelect('PRAGMA table_info($table)').get()).map(
              (r) => r.data,
            ),
          );
        }
        expect(
          await db.customSelect('PRAGMA foreign_key_check').get(),
          isEmpty,
        );
      } finally {
        await db.close();
        await fresh.close();
      }
    },
  );

  test(
    'v3 needs backup and auth collision preserves old database and snapshot',
    () async {
      createV3(file);
      await expectLater(
        PosDatabase.open(file),
        throwsA(isA<MigrationBackupRequiredException>()),
      );
      final raw = sqlite3.open(file.path);
      raw.execute('CREATE TABLE staff_credentials (note TEXT)');
      raw.execute("INSERT INTO staff_credentials VALUES ('preserve')");
      raw.close();
      await expectLater(
        PosDatabase.open(file, migrationBackup: policy()),
        throwsA(isA<DatabaseMigrationException>()),
      );
      expect(version(file), 3);
      expect(await backups.list().length, 1);
      final after = sqlite3.open(file.path, mode: OpenMode.readOnly);
      try {
        expect(
          after.select('SELECT note FROM staff_credentials').single['note'],
          'preserve',
        );
      } finally {
        after.close();
      }
    },
  );

  test('missing active PIN uniqueness index refuses reopening', () async {
    final db = await PosDatabase.open(file);
    await db.customStatement('DROP INDEX active_pin_fingerprints');
    await db.close();
    await expectLater(PosDatabase.open(file), throwsA(anything));
  });
}
