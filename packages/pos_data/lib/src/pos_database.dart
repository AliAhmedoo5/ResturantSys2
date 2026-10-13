import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

part 'pos_database.g.dart';

/// Storage foundation only. Not yet connected to the preview or business commands.
@DriftDatabase(include: {'schema.drift'})
class PosDatabase extends _$PosDatabase {
  PosDatabase._(QueryExecutor executor) : super(executor);

  static const currentSchemaVersion = 1;
  // ASCII CCRT, within SQLite's signed 32-bit application_id range.
  static const applicationId = 0x43435254;

  /// The caller supplies an absolute file in a provisioned local data directory.
  /// Failures are propagated; no reset, repair or in-memory fallback is attempted.
  static Future<PosDatabase> open(File file) async {
    if (!file.isAbsolute || file.path.startsWith(r'\\') ||
        file.path.startsWith('//')) {
      throw ArgumentError('An absolute local database file is required.');
    }
    final database = PosDatabase._(
      NativeDatabase.createInBackground(file, setup: _configureConnection),
    );
    try {
      await database.customSelect('SELECT 1').getSingle();
      return database;
    } catch (_) {
      await database.close();
      rethrow;
    }
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
    // There is no older released database schema. Never guess an upgrade path.
    onUpgrade: (migrator, from, to) async {
      throw StateError('Unsupported database migration: $from -> $to');
    },
    beforeOpen: (_) async {
      await customStatement('PRAGMA foreign_keys = ON');
      final identity = await customSelect(
        'SELECT singleton, format_tag FROM database_metadata',
      ).get();
      if (identity.length != 1 || identity.single.read<int>('singleton') != 1 ||
          identity.single.read<String>('format_tag') != 'crunch-cartel') {
        throw StateError('Database identity is invalid.');
      }
      final integrity = await customSelect('PRAGMA quick_check').get();
      if (integrity.length != 1 || integrity.single.data.values.single != 'ok') {
        throw StateError('Database integrity check failed.');
      }
      if ((await customSelect('PRAGMA foreign_key_check').get()).isNotEmpty) {
        throw StateError('Database foreign key check failed.');
      }
    },
  );
}

// Runs in the database isolate, before Drift can perform schema mutations.
void _configureConnection(sqlite.Database database) {
  final version = database.select('PRAGMA user_version').single.values.single as int;
  final appId = database.select('PRAGMA application_id').single.values.single as int;
  final objects = database.select(
    "SELECT name FROM sqlite_master WHERE name NOT LIKE 'sqlite_%'",
  );
  final fresh = version == 0 && appId == 0 && objects.isEmpty;
  if (!fresh && (appId != PosDatabase.applicationId ||
      version != PosDatabase.currentSchemaVersion)) {
    throw StateError('Unsupported database identity or schema version.');
  }
  database.execute('PRAGMA busy_timeout = 5000');
  final mode = database.select('PRAGMA journal_mode = WAL').single.values.single;
  if (mode != 'wal') throw StateError('WAL mode is required.');
  database.execute('PRAGMA synchronous = FULL');
  database.execute('PRAGMA foreign_keys = ON');
  database.execute('PRAGMA wal_autocheckpoint = 1000');
}
