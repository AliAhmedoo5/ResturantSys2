import 'dart:io';

import 'package:pos_data/pos_data.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';

void main() {
  late Directory folder;
  late File file;
  setUp(() async {
    folder = await Directory.systemTemp.createTemp('cartel-database-test-');
    file = File('${folder.path}/pos.db');
  });
  tearDown(() async {
    await folder.delete(recursive: true);
  });

  test(
    'fresh file has version, identity and durable connection settings',
    () async {
      final db = await PosDatabase.open(file);
      try {
        for (final entry in {
          'user_version': 1,
          'application_id': PosDatabase.applicationId,
          'journal_mode': 'wal',
          'foreign_keys': 1,
          'busy_timeout': 5000,
          'synchronous': 2,
          'wal_autocheckpoint': 1000,
        }.entries) {
          final row = await db.customSelect('PRAGMA ${entry.key}').getSingle();
          expect(row.data.values.single, entry.value, reason: entry.key);
        }
        expect(
          (await db.customSelect('SELECT * FROM database_metadata').get())
              .length,
          1,
        );
      } finally {
        await db.close();
      }
      expect(await file.exists(), isTrue);
      final reopened = await PosDatabase.open(file);
      await reopened.close();
    },
  );

  test('committed rows survive close and failed transaction rolls back', () async {
    final db = await PosDatabase.open(file);
    try {
      // Test-only probe: no synthetic sales or financial schema in production.
      await db.customStatement(
        'CREATE TABLE durability_probe (id INTEGER PRIMARY KEY, note TEXT NOT NULL)',
      );
      await db.transaction(() async {
        await db.customStatement(
          "INSERT INTO durability_probe VALUES (1, 'committed')",
        );
      });
      await expectLater(
        db.transaction(() async {
          await db.customStatement(
            "INSERT INTO durability_probe VALUES (2, 'rolled back')",
          );
          throw StateError('simulated command failure');
        }),
        throwsStateError,
      );
    } finally {
      await db.close();
    }
    final reopened = await PosDatabase.open(file);
    try {
      final rows = await reopened
          .customSelect('SELECT * FROM durability_probe')
          .get();
      expect(rows.length, 1);
      expect(rows.single.read<String>('note'), 'committed');
    } finally {
      await reopened.close();
    }
  });

  test('SQLite rejects invalid metadata and foreign key writes', () async {
    final db = await PosDatabase.open(file);
    try {
      await expectLater(
        db.customStatement(
          "INSERT INTO database_metadata VALUES (2, 'crunch-cartel')",
        ),
        throwsA(anything),
      );
      await expectLater(
        db.customStatement("UPDATE database_metadata SET format_tag = 'other'"),
        throwsA(anything),
      );
      await db.customStatement(
        'CREATE TABLE fk_probe (id INTEGER REFERENCES database_metadata(singleton))',
      );
      await expectLater(
        db.customStatement('INSERT INTO fk_probe VALUES (99)'),
        throwsA(anything),
      );
    } finally {
      await db.close();
    }
  });

  for (final version in [0, 1, 99]) {
    test(
      'unrelated schema version $version is refused without changing the file',
      () async {
        final raw = sqlite3.open(file.path);
        raw.execute('CREATE TABLE unrelated (note TEXT)');
        raw.execute("INSERT INTO unrelated VALUES ('keep me')");
        raw.execute('PRAGMA user_version = $version');
        raw.close();
        final original = await file.readAsBytes();
        await expectLater(PosDatabase.open(file), throwsA(anything));
        expect(await file.readAsBytes(), original);
      },
    );
  }

  test('newer Crunch Cartel schema is refused without downgrading', () async {
    final db = await PosDatabase.open(file);
    await db.close();
    final raw = sqlite3.open(file.path);
    raw.execute('PRAGMA user_version = 99');
    raw.close();
    final original = await file.readAsBytes();
    await expectLater(PosDatabase.open(file), throwsA(anything));
    expect(await file.readAsBytes(), original);
  });

  test('corrupt file is preserved instead of reset', () async {
    await file.writeAsString('not a database');
    final original = await file.readAsBytes();
    await expectLater(PosDatabase.open(file), throwsA(anything));
    expect(await file.readAsBytes(), original);
  });

  test('missing metadata is refused instead of silently reseeded', () async {
    final db = await PosDatabase.open(file);
    await db.customStatement('DELETE FROM database_metadata');
    await db.close();
    await expectLater(PosDatabase.open(file), throwsA(anything));
    final raw = sqlite3.open(file.path);
    expect(raw.select('SELECT * FROM database_metadata'), isEmpty);
    raw.close();
  });

  test('relative and network paths are rejected', () async {
    for (final name in [
      'relative.db',
      r'\\server\share\pos.db',
      '//server/share/pos.db',
    ]) {
      await expectLater(PosDatabase.open(File(name)), throwsArgumentError);
    }
  });
}
