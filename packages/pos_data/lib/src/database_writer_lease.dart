import 'dart:io';

/// Another process or database instance already owns this database's writer.
class DatabaseAlreadyOpenException implements Exception {
  const DatabaseAlreadyOpenException();

  @override
  String toString() => 'This database is already open in another instance.';
}

/// Windows handle-owned lock. The marker is never deleted: ownership comes from
/// the OS lock, so a crash or stale marker cannot strand the next application.
class DatabaseWriterLease {
  DatabaseWriterLease._(this.file, this._handle);

  final File file;
  final RandomAccessFile _handle;
  Future<void>? _release;

  static Future<DatabaseWriterLease> acquire(File requestedFile) async {
    // POS deployment and locking semantics are Windows-specific. Do not claim
    // process-wide exclusion using Unix advisory locks with different semantics.
    if (!Platform.isWindows) {
      throw UnsupportedError('The POS writer lease requires Windows.');
    }
    _requireLocalAbsolutePath(requestedFile);
    final File canonicalFile;
    if (await requestedFile.exists()) {
      canonicalFile = File(await requestedFile.resolveSymbolicLinks());
    } else {
      final directory = await requestedFile.parent.resolveSymbolicLinks();
      final name = requestedFile.uri.pathSegments.last;
      canonicalFile = File.fromUri(
        Directory(directory).uri.resolveUri(Uri(path: name)),
      );
    }
    _requireLocalAbsolutePath(canonicalFile);
    final handle = await File(
      '${canonicalFile.path}.writer.lock',
    ).open(mode: FileMode.append);
    try {
      // A single fixed byte range also works on an empty marker file.
      await handle.lock(FileLock.exclusive, 0, 1);
    } on FileSystemException catch (error) {
      await handle.close();
      // ERROR_LOCK_VIOLATION, not access-denied, missing storage or disk failure.
      if (error.osError?.errorCode == 33) {
        throw const DatabaseAlreadyOpenException();
      }
      rethrow;
    } catch (_) {
      await handle.close();
      rethrow;
    }
    return DatabaseWriterLease._(canonicalFile, handle);
  }

  Future<void> release() => _release ??= _releaseHandle();

  Future<void> _releaseHandle() async {
    try {
      await _handle.unlock(0, 1);
    } finally {
      await _handle.close();
    }
  }
}

void _requireLocalAbsolutePath(File file) {
  if (!file.isAbsolute ||
      file.path.startsWith(r'\\') ||
      file.path.startsWith('//')) {
    throw ArgumentError('An absolute local database file is required.');
  }
}
