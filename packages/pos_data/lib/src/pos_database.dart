import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import 'database_writer_lease.dart';
import 'backup_snapshot.dart';
import 'migration_backup.dart';

part 'pos_database.g.dart';

/// Storage foundation only. Not yet connected to the preview or business commands.
@DriftDatabase(include: {'schema.drift'})
class PosDatabase extends _$PosDatabase {
  PosDatabase._(
    QueryExecutor executor,
    this._writerLease,
    this._migrationBackup,
  ) : super(executor);

  final DatabaseWriterLease _writerLease;
  final MigrationBackup? _migrationBackup;
  (Object, StackTrace)? _migrationFailure;
  Future<void>? _closing;
  final Object _transactionScope = Object();

  bool get isInsideTransaction => Zone.current[_transactionScope] == true;

  @override
  Future<T> transaction<T>(Future<T> Function() action, {bool requireNew = false}) =>
      super.transaction(
        () => runZoned(action, zoneValues: {_transactionScope: true}),
        requireNew: requireNew,
      );

  /// Internal backup seam; callers must await completion before closing storage.
  /// Never invoke from inside a transaction or use this as restore authorization.
  Future<DatabaseSnapshot> createSnapshot(
    Directory destination, {
    required String appVersion,
  }) => createVerifiedSnapshot(
    this,
    destination,
    appVersion: appVersion,
    applicationId: applicationId,
  );

  static Future<DatabaseSnapshot> verifySnapshot(Directory directory) =>
      verifyDatabaseSnapshot(
        directory,
        applicationId: applicationId,
        maximumSchemaVersion: currentSchemaVersion,
      );

  static const currentSchemaVersion = 3;
  // ASCII CCRT, within SQLite's signed 32-bit application_id range.
  static const applicationId = 0x43435254;

  /// The caller supplies an absolute file in a provisioned local data directory.
  /// Failures are propagated; no reset, repair or in-memory fallback is attempted.
  static Future<PosDatabase> open(
    File file, {
    MigrationBackup? migrationBackup,
  }) async {
    final lease = await DatabaseWriterLease.acquire(file);
    final PosDatabase database;
    try {
      database = PosDatabase._(
        NativeDatabase.createInBackground(
          lease.file,
          setup: _configureConnection,
        ),
        lease,
        migrationBackup,
      );
    } catch (_) {
      await lease.release();
      rethrow;
    }
    try {
      await database.customSelect('SELECT 1').getSingle();
      return database;
    } catch (error, stack) {
      await database.close();
      final failure = database._migrationFailure;
      Error.throwWithStackTrace(failure?.$1 ?? error, failure?.$2 ?? stack);
    }
  }

  @override
  Future<void> close() => _closing ??= _closeWithLease();

  Future<void> _closeWithLease() async {
    // Keep ownership until SQLite and its isolate are actually closed. If closing
    // fails, fail closed: process termination will release the OS handle.
    await super.close();
    await _writerLease.release();
  }

  @override
  int get schemaVersion => currentSchemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await transaction(() async {
        await migrator.createAll();
        await customStatement(
          "INSERT INTO database_metadata VALUES (1, 'crunch-cartel')",
        );
        await customStatement('PRAGMA application_id = $applicationId');
      });
    },
    onUpgrade: (migrator, from, to) => _recordMigrationFailure(() async {
      if ((from != 1 && from != 2) || to != 3) {
        throw StateError('Unsupported database migration: $from -> $to');
      }
      final policy = _migrationBackup;
      if (policy == null) throw const MigrationBackupRequiredException();
      // Drift does not wrap onUpgrade in a transaction. VACUUM INTO must finish
      // outside it; the writer lease remains held throughout backup and upgrade.
      final snapshot = await createSnapshot(
        policy.directory,
        appVersion: policy.appVersion,
      );
      final verified = await verifySnapshot(snapshot.directory);
      if (verified.schemaVersion != from ||
          verified.sha256Hex != snapshot.sha256Hex) {
        throw StateError('Pre-migration snapshot does not match the source.');
      }
      try {
        await transaction(() async {
          if (from == 1) await migrator.createTable(schemaUpgrades);
          final collisions = await customSelect(
            "SELECT name FROM sqlite_master WHERE name IN ('idempotency_commands', 'command_versions', 'audit_events', 'audit_events_no_update', 'audit_events_no_delete', 'commands_no_update', 'commands_no_delete')",
          ).get();
          if (collisions.isNotEmpty) {
            throw StateError('Command schema already exists in an old database.');
          }
          await migrator.createTable(idempotencyCommands);
          await migrator.createTable(commandVersions);
          await migrator.createTable(auditEvents);
          for (final trigger in allSchemaEntities.whereType<Trigger>()) {
            await migrator.createTrigger(trigger);
          }
          await customStatement(
            'INSERT INTO schema_upgrades (to_version, from_version, applied_at_utc, app_version, backup_directory, backup_sha256) VALUES (?, ?, ?, ?, ?, ?)',
            [
              to,
              from,
              DateTime.now().toUtc().toIso8601String(),
              policy.appVersion,
              verified.directory.path,
              verified.sha256Hex,
            ],
          );
          await _checkIntegrity();
          // Persist version and schema together; Drift's later version write is
          // idempotent. A process exit cannot leave new tables labelled v1.
          await customStatement('PRAGMA user_version = 3');
        });
      } catch (error) {
        throw DatabaseMigrationException(
          backupDirectory: verified.directory,
          cause: error,
        );
      }
    }),
    beforeOpen: (_) async {
      await customStatement('PRAGMA foreign_keys = ON');
      final identity = await customSelect(
        'SELECT singleton, format_tag FROM database_metadata',
      ).get();
      if (identity.length != 1 ||
          identity.single.read<int>('singleton') != 1 ||
          identity.single.read<String>('format_tag') != 'crunch-cartel') {
        throw StateError('Database identity is invalid.');
      }
      final integrity = await customSelect('PRAGMA quick_check').get();
      if (integrity.length != 1 ||
          integrity.single.data.values.single != 'ok') {
        throw StateError('Database integrity check failed.');
      }
      if ((await customSelect('PRAGMA foreign_key_check').get()).isNotEmpty) {
        throw StateError('Database foreign key check failed.');
      }
      // Also fail closed if a v2 database has lost its technical history table.
      await customSelect(
        'SELECT to_version, from_version, applied_at_utc, app_version, backup_directory, backup_sha256 FROM schema_upgrades LIMIT 1',
      ).get();
      await customSelect('SELECT intent_key, kind, request_hash, result_json, created_at_utc FROM idempotency_commands LIMIT 1').get();
      await customSelect('SELECT entity_type, entity_id, revision FROM command_versions LIMIT 1').get();
      await customSelect('SELECT id, command_id, entity_type, entity_id, event_type, actor_id, session_id, approver_id, business_day_id, terminal_id, app_version, reason, before_json, after_json, created_at_utc FROM audit_events LIMIT 1').get();
      for (final trigger in allSchemaEntities.whereType<Trigger>()) {
        final stored = await customSelect(
          'SELECT name FROM sqlite_master WHERE type = ? AND name = ?',
          variables: [Variable('trigger'), Variable(trigger.entityName)],
        ).get();
        if (stored.length != 1) throw StateError('Missing immutable-history guard.');
      }
    },
  );

  Future<void> _recordMigrationFailure(Future<void> Function() upgrade) async {
    try {
      await upgrade();
    } catch (error, stack) {
      // Drift calls this callback on the client, then wraps failures across its
      // remote opening handshake. Keep the typed cause and archive for callers.
      _migrationFailure = (error, stack);
      rethrow;
    }
  }

  Future<void> _checkIntegrity() async {
    final integrity = await customSelect('PRAGMA integrity_check').get();
    if (integrity.length != 1 ||
        integrity.single.data.values.single != 'ok' ||
        (await customSelect('PRAGMA foreign_key_check').get()).isNotEmpty) {
      throw StateError('Migration integrity verification failed.');
    }
  }
}

// Runs in the database isolate, before Drift can perform schema mutations.
void _configureConnection(sqlite.Database database) {
  final version =
      database.select('PRAGMA user_version').single.values.single as int;
  final appId =
      database.select('PRAGMA application_id').single.values.single as int;
  final objects = database.select(
    "SELECT name FROM sqlite_master WHERE name NOT GLOB 'sqlite_*'",
  );
  final fresh = version == 0 && appId == 0 && objects.isEmpty;
  if (!fresh &&
      (appId != PosDatabase.applicationId ||
          version < 1 ||
          version > PosDatabase.currentSchemaVersion)) {
    throw StateError('Unsupported database identity or schema version.');
  }
  if (!fresh) {
    final identity = database.select(
      'SELECT singleton, format_tag FROM database_metadata',
    );
    final integrity = database.select('PRAGMA integrity_check');
    if (identity.length != 1 ||
        identity.single['singleton'] != 1 ||
        identity.single['format_tag'] != 'crunch-cartel' ||
        integrity.length != 1 ||
        integrity.single.values.single != 'ok' ||
        database.select('PRAGMA foreign_key_check').isNotEmpty) {
      throw StateError('Source database validation failed before migration.');
    }
  }
  database.execute('PRAGMA busy_timeout = 5000');
  final mode = database
      .select('PRAGMA journal_mode = WAL')
      .single
      .values
      .single;
  if (mode != 'wal') throw StateError('WAL mode is required.');
  database.execute('PRAGMA synchronous = FULL');
  database.execute('PRAGMA foreign_keys = ON');
  database.execute('PRAGMA wal_autocheckpoint = 1000');
}
