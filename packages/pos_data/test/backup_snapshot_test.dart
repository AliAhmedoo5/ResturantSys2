@TestOn('windows')
library;

import 'dart:convert';
import 'dart:io';

import 'package:pos_data/pos_data.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';

void main() {
  late Directory root;
  late Directory destination;
  late PosDatabase database;
  setUp(() async {
    root = await Directory.systemTemp.createTemp('cartel-backup-test-');
    destination = await Directory('${root.path}/backups').create();
    database = await PosDatabase.open(File('${root.path}/pos.db'));
    await database.customStatement('PRAGMA wal_autocheckpoint = 0');
    await database.customStatement('CREATE TABLE backup_probe (id INTEGER PRIMARY KEY, amount_paisa INTEGER NOT NULL)');
  });
  tearDown(() async {
    await database.close();
    await root.delete(recursive: true);
  });

  test('snapshot includes committed WAL rows and survives source changes', () async {
    await database.customStatement('INSERT INTO backup_probe VALUES (1, 61625)');
    expect(await File('${root.path}/pos.db-wal').length(), greaterThan(0));
    final snapshot = await database.createSnapshot(destination, appVersion: '0.2.0+2');
    await database.customStatement('INSERT INTO backup_probe VALUES (2, 20000)');
    final checked = await PosDatabase.verifySnapshot(snapshot.directory);
    expect(checked.sha256Hex, snapshot.sha256Hex);
    expect(checked.schemaVersion, 1);
    expect(checked.createdAtUtc.isUtc, isTrue);
    expect(checked.appVersion, '0.2.0+2');
    final copy = sqlite3.open(checked.databaseFile.path, mode: OpenMode.readOnly);
    try {
      final rows = copy.select('SELECT * FROM backup_probe');
      expect(rows.length, 1);
      expect(rows.single['amount_paisa'], 61625);
      expect(copy.select('PRAGMA journal_mode').single.values.single, 'delete');
    } finally {
      copy.close();
    }
    final archives = await destination.list().toList();
    expect(archives.length, 1);
    expect((await snapshot.directory.list().toList()).length, 2);
    // A new connection to the archive works without copying the source WAL.
    final restored = await PosDatabase.open(snapshot.databaseFile);
    try {
      expect((await restored.customSelect('SELECT COUNT(*) AS n FROM backup_probe').getSingle()).read<int>('n'), 1);
    } finally {
      await restored.close();
    }
  });

  test('repeated backups are distinct and preserve older content', () async {
    final first = await database.createSnapshot(destination, appVersion: 'test');
    await database.customStatement('INSERT INTO backup_probe VALUES (1, 1)');
    final second = await database.createSnapshot(destination, appVersion: 'test');
    expect(first.directory.path, isNot(second.directory.path));
    expect(first.sha256Hex, isNot(second.sha256Hex));
    await PosDatabase.verifySnapshot(first.directory);
    await PosDatabase.verifySnapshot(second.directory);
  });

  test('backup inside a transaction fails without publishing partial output', () async {
    await expectLater(database.transaction(() async {
      await database.customStatement('INSERT INTO backup_probe VALUES (1, 1)');
      await database.createSnapshot(destination, appVersion: 'test');
    }), throwsA(anything));
    expect(await destination.list().toList(), isEmpty);
    expect((await database.customSelect('SELECT * FROM backup_probe').get()), isEmpty);
    await database.createSnapshot(destination, appVersion: 'test');
  });

  test('missing destination is not recreated and source remains usable', () async {
    final missing = Directory('${root.path}/disconnected');
    await expectLater(database.createSnapshot(missing, appVersion: 'test'), throwsA(isA<FileSystemException>()));
    expect(await missing.exists(), isFalse);
    await database.customStatement('INSERT INTO backup_probe VALUES (1, 1)');
  });

  test('invalid metadata in source prevents publication and cleans staging', () async {
    await database.customStatement('DELETE FROM database_metadata');
    await expectLater(database.createSnapshot(destination, appVersion: 'test'), throwsA(anything));
    expect(await destination.list().toList(), isEmpty);
  });

  test('foreign key violations prevent publication', () async {
    await database.customStatement('PRAGMA foreign_keys = OFF');
    await database.customStatement('CREATE TABLE orphan_probe (id INTEGER REFERENCES database_metadata(singleton))');
    await database.customStatement('INSERT INTO orphan_probe VALUES (99)');
    await database.customStatement('PRAGMA foreign_keys = ON');
    await expectLater(database.createSnapshot(destination, appVersion: 'test'), throwsA(anything));
    expect(await destination.list().toList(), isEmpty);
  });

  test('changed snapshot content is rejected without modifying it', () async {
    final snapshot = await database.createSnapshot(destination, appVersion: 'test');
    final copy = sqlite3.open(snapshot.databaseFile.path, mode: OpenMode.readWrite);
    copy.execute('INSERT INTO backup_probe VALUES (1, 99)');
    copy.close();
    final modified = await snapshot.databaseFile.readAsBytes();
    await expectLater(PosDatabase.verifySnapshot(snapshot.directory), throwsFormatException);
    expect(await snapshot.databaseFile.readAsBytes(), modified);
  });

  for (final field in ['schemaVersion', 'applicationId', 'sizeBytes', 'formatVersion']) {
    test('manifest mismatch for $field is rejected', () async {
      final snapshot = await database.createSnapshot(destination, appVersion: 'test');
      final manifestFile = File.fromUri(snapshot.directory.uri.resolve('manifest.json'));
      final manifest = jsonDecode(await manifestFile.readAsString()) as Map<String, dynamic>;
      manifest[field] = -1;
      await manifestFile.writeAsString(jsonEncode(manifest));
      await expectLater(PosDatabase.verifySnapshot(snapshot.directory), throwsFormatException);
    });
  }

  test('missing manifest is rejected instead of trusting the database alone', () async {
    final snapshot = await database.createSnapshot(destination, appVersion: 'test');
    await File.fromUri(snapshot.directory.uri.resolve('manifest.json')).delete();
    await expectLater(PosDatabase.verifySnapshot(snapshot.directory), throwsFormatException);
  });

  test('invalid app version and relative destination create no artifacts', () async {
    await expectLater(database.createSnapshot(destination, appVersion: ''), throwsArgumentError);
    await expectLater(database.createSnapshot(Directory('relative'), appVersion: 'test'), throwsArgumentError);
    expect(await destination.list().toList(), isEmpty);
  });
}
