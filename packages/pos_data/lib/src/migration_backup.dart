import 'dart:io';

/// Caller-provisioned destination; no directory is created implicitly.
class MigrationBackup {
  const MigrationBackup({required this.directory, required this.appVersion});

  final Directory directory;
  final String appVersion;
}

class MigrationBackupRequiredException implements Exception {
  const MigrationBackupRequiredException();

  @override
  String toString() =>
      'A verified pre-migration backup is required to upgrade this database.';
}

/// The original database transaction rolled back; retain this archive for repair.
/// This exception never authorizes an automatic file replacement or restore.
class DatabaseMigrationException implements Exception {
  const DatabaseMigrationException({
    required this.backupDirectory,
    required this.cause,
  });

  final Directory backupDirectory;
  final Object cause;

  @override
  String toString() =>
      'Database upgrade failed. Original data and the pre-migration snapshot were retained.';
}
