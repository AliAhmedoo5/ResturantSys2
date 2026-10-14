import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

/// Verified, unencrypted internal snapshot. This is not a restore authorization.
class DatabaseSnapshot {
  const DatabaseSnapshot({
    required this.directory,
    required this.schemaVersion,
    required this.createdAtUtc,
    required this.appVersion,
    required this.sha256Hex,
    required this.sizeBytes,
  });

  final Directory directory;
  final int schemaVersion;
  final DateTime createdAtUtc;
  final String appVersion;
  final String sha256Hex;
  final int sizeBytes;

  File get databaseFile =>
      File.fromUri(directory.uri.resolve('database.sqlite'));
}

Future<DatabaseSnapshot> createVerifiedSnapshot(
  GeneratedDatabase database,
  Directory destination, {
  required String appVersion,
  required int applicationId,
}) async {
  _validateDirectory(destination);
  _validateAppVersion(appVersion);
  // Do not silently recreate a missing/disconnected backup destination.
  final canonical = Directory(await destination.resolveSymbolicLinks());
  _validateDirectory(canonical);
  final pending = await canonical.createTemp('.pending-');
  final snapshotFile = File.fromUri(pending.uri.resolve('database.sqlite'));
  final published = Directory.fromUri(
    canonical.uri.resolve(
      'snapshot-${pending.uri.pathSegments.where((part) => part.isNotEmpty).last.substring(9)}',
    ),
  );
  var completed = false;
  try {
    // This statement uses SQLite's consistent snapshot mechanism, never a copy
    // of the live main file. It intentionally fails inside an open transaction.
    await database.customStatement('VACUUM INTO ?', [snapshotFile.path]);
    final schemaVersion = database.schemaVersion;
    final pendingPath = pending.path;
    final result = await Isolate.run(() async {
      final stagedFile = File.fromUri(
        Directory(pendingPath).uri.resolve('database.sqlite'),
      );
      // Make the snapshot standalone before hashing; only the copy is modified.
      final copy = sqlite.sqlite3.open(
        stagedFile.path,
        mode: sqlite.OpenMode.readWrite,
      );
      try {
        final mode = copy
            .select('PRAGMA journal_mode = DELETE')
            .single
            .values
            .single;
        if (mode != 'delete') throw StateError('Snapshot must be standalone.');
        _verifySqlite(copy, applicationId, schemaVersion);
      } finally {
        copy.close();
      }
      final digest = (await sha256.bind(stagedFile.openRead()).first)
          .toString();
      final size = await stagedFile.length();
      final createdAt = DateTime.now().toUtc();
      final manifest = {
        'formatVersion': 1,
        'applicationId': applicationId,
        'schemaVersion': schemaVersion,
        'createdAtUtc': createdAt.toIso8601String(),
        'appVersion': appVersion,
        'sizeBytes': size,
        'sha256': digest,
        'integrityVerified': true,
        'encrypted': false,
        'businessDayId': null,
      };
      await File.fromUri(
        Directory(pendingPath).uri.resolve('manifest.json'),
      ).writeAsString(jsonEncode(manifest), flush: true);
      return (digest: digest, size: size, createdAt: createdAt);
    });
    // Same-parent directory rename publishes database and manifest together.
    if (await FileSystemEntity.type(published.path, followLinks: false) !=
        FileSystemEntityType.notFound) {
      throw StateError('Snapshot destination already exists.');
    }
    await pending.rename(published.path);
    completed = true;
    return DatabaseSnapshot(
      directory: published,
      schemaVersion: schemaVersion,
      createdAtUtc: result.createdAt,
      appVersion: appVersion,
      sha256Hex: result.digest,
      sizeBytes: result.size,
    );
  } finally {
    if (!completed && await pending.exists()) {
      // Only this call's newly created staging directory can be removed.
      await pending.delete(recursive: true);
    }
  }
}

Future<DatabaseSnapshot> verifyDatabaseSnapshot(
  Directory directory, {
  required int applicationId,
  required int maximumSchemaVersion,
}) async {
  _validateDirectory(directory);
  final path = await directory.resolveSymbolicLinks();
  _validateDirectory(Directory(path));
  return Isolate.run(() async {
    final folder = Directory(path);
    final dataFile = File.fromUri(folder.uri.resolve('database.sqlite'));
    final manifestFile = File.fromUri(folder.uri.resolve('manifest.json'));
    for (final file in [dataFile, manifestFile]) {
      if (await FileSystemEntity.type(file.path, followLinks: false) !=
          FileSystemEntityType.file) {
        throw FormatException(
          'Snapshot requires ordinary database and manifest files.',
        );
      }
    }
    if (await manifestFile.length() > 16384)
      throw FormatException('Snapshot manifest is too large.');
    final manifest = jsonDecode(await manifestFile.readAsString());
    if (manifest is! Map<String, dynamic> ||
        manifest['formatVersion'] != 1 ||
        manifest['applicationId'] != applicationId ||
        manifest['encrypted'] != false ||
        manifest['integrityVerified'] != true ||
        manifest['schemaVersion'] is! int ||
        manifest['schemaVersion'] < 1 ||
        manifest['schemaVersion'] > maximumSchemaVersion ||
        manifest['sizeBytes'] is! int ||
        manifest['sizeBytes'] <= 0 ||
        manifest['sha256'] is! String ||
        !RegExp(r'^[0-9a-f]{64}$').hasMatch(manifest['sha256']) ||
        manifest['createdAtUtc'] is! String ||
        manifest['appVersion'] is! String) {
      throw FormatException('Unsupported or invalid snapshot manifest.');
    }
    _validateAppVersion(manifest['appVersion'] as String);
    final timestamp = DateTime.tryParse(manifest['createdAtUtc'] as String);
    if (timestamp == null || !timestamp.isUtc)
      throw FormatException('Snapshot timestamp must be UTC.');
    final size = await dataFile.length();
    final digest = (await sha256.bind(dataFile.openRead()).first).toString();
    if (size != manifest['sizeBytes'] || digest != manifest['sha256']) {
      throw FormatException('Snapshot checksum or size does not match.');
    }
    final copy = sqlite.sqlite3.open(
      dataFile.path,
      mode: sqlite.OpenMode.readOnly,
    );
    try {
      _verifySqlite(copy, applicationId, manifest['schemaVersion'] as int);
    } finally {
      copy.close();
    }
    return DatabaseSnapshot(
      directory: folder,
      schemaVersion: manifest['schemaVersion'] as int,
      createdAtUtc: timestamp,
      appVersion: manifest['appVersion'] as String,
      sha256Hex: digest,
      sizeBytes: size,
    );
  });
}

void _verifySqlite(
  sqlite.Database database,
  int applicationId,
  int schemaVersion,
) {
  if (database.select('PRAGMA application_id').single.values.single !=
          applicationId ||
      database.select('PRAGMA user_version').single.values.single !=
          schemaVersion ||
      database.select('PRAGMA journal_mode').single.values.single != 'delete') {
    throw FormatException(
      'Snapshot database identity or version does not match.',
    );
  }
  final identity = database.select(
    'SELECT singleton, format_tag FROM database_metadata',
  );
  if (identity.length != 1 ||
      identity.single['singleton'] != 1 ||
      identity.single['format_tag'] != 'crunch-cartel') {
    throw FormatException('Snapshot database identity is invalid.');
  }
  final integrity = database.select('PRAGMA integrity_check');
  if (integrity.length != 1 ||
      integrity.single.values.single != 'ok' ||
      database.select('PRAGMA foreign_key_check').isNotEmpty) {
    throw FormatException('Snapshot integrity verification failed.');
  }
}

void _validateDirectory(Directory directory) {
  if (!directory.isAbsolute ||
      directory.path.startsWith(r'\\') ||
      directory.path.startsWith('//')) {
    throw ArgumentError('An absolute local snapshot directory is required.');
  }
}

void _validateAppVersion(String version) {
  if (!RegExp(r'^[A-Za-z0-9][A-Za-z0-9.+_-]{0,63}$').hasMatch(version)) {
    throw ArgumentError('A valid application version is required.');
  }
}
