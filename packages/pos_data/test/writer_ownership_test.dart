@TestOn('windows')
@Timeout(Duration(minutes: 2))
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:pos_data/pos_data.dart';
import 'package:test/test.dart';

void main() {
  late Directory directory;
  late File file;
  setUp(() async {
    directory = await Directory.systemTemp.createTemp('cartel-writer-test-');
    file = File('${directory.path}/pos.db');
  });
  tearDown(() async {
    await directory.delete(recursive: true);
  });

  test(
    'second instance is denied and repeated close releases ownership',
    () async {
      final first = await PosDatabase.open(file);
      try {
        await expectLater(
          PosDatabase.open(file),
          throwsA(isA<DatabaseAlreadyOpenException>()),
        );
        await expectLater(
          PosDatabase.open(file),
          throwsA(isA<DatabaseAlreadyOpenException>()),
        );
        await first.customSelect('SELECT 1').getSingle();
      } finally {
        await Future.wait([first.close(), first.close()]);
      }
      final reopened = await PosDatabase.open(file);
      await reopened.close();
    },
  );

  test('concurrent first opens produce exactly one writer', () async {
    Future<PosDatabase?> attempt() async {
      try {
        return await PosDatabase.open(file);
      } on DatabaseAlreadyOpenException {
        return null;
      }
    }

    final results = await Future.wait([attempt(), attempt(), attempt()]);
    try {
      expect(results.whereType<PosDatabase>().length, 1);
    } finally {
      for (final database in results.whereType<PosDatabase>()) {
        await database.close();
      }
    }
  });

  test('equivalent paths share the same writer lease', () async {
    final first = await PosDatabase.open(file);
    try {
      final alias = File('${directory.path}/./pos.db');
      await expectLater(
        PosDatabase.open(alias),
        throwsA(isA<DatabaseAlreadyOpenException>()),
      );
      await expectLater(
        PosDatabase.open(File(file.path.toUpperCase())),
        throwsA(isA<DatabaseAlreadyOpenException>()),
      );
    } finally {
      await first.close();
    }
  });

  test('old marker does not prevent opening or get deleted', () async {
    final marker = File('${file.path}.writer.lock');
    await marker.writeAsString('old marker');
    final database = await PosDatabase.open(file);
    await database.close();
    expect(await marker.readAsString(), 'old marker');
  });

  test('failed database open releases the lease', () async {
    await file.writeAsString('corrupt');
    await expectLater(PosDatabase.open(file), throwsA(anything));
    // Test fixture repair after failure, not a production reset path.
    await file.delete();
    final database = await PosDatabase.open(file);
    await database.close();
  });

  test(
    'missing directory preserves storage error instead of reporting contention',
    () async {
      await expectLater(
        PosDatabase.open(File('${directory.path}/missing/pos.db')),
        throwsA(isA<FileSystemException>()),
      );
    },
  );

  for (final command in ['close', 'crash']) {
    test('child process owns writer until $command', () async {
      final dartHome = Platform.environment['DART_HOME'];
      if (dartHome == null) throw StateError('Hosted Dart SDK path is required.');
      final child = await Process.start('$dartHome/bin/dart.exe', [
        'run',
        'test/support/writer_process.dart',
        file.path,
      ]);
      final errors = child.stderr.transform(utf8.decoder).join();
      final output = StreamIterator(
        child.stdout.transform(utf8.decoder).transform(const LineSplitter()),
      );
      try {
        var ready = false;
        while (await output.moveNext().timeout(const Duration(seconds: 60))) {
          if (output.current == 'READY') {
            ready = true;
            break;
          }
        }
        expect(ready, isTrue, reason: ready ? null : await errors);
        await expectLater(
          PosDatabase.open(file),
          throwsA(isA<DatabaseAlreadyOpenException>()),
        );
        child.stdin.writeln(command);
        await child.stdin.flush();
        expect(
          await child.exitCode.timeout(const Duration(seconds: 20)),
          0,
          reason: await errors,
        );
        final reopened = await PosDatabase.open(file);
        await reopened.close();
      } finally {
        // If assertions fail, ask the helper to exit before deleting its fixture.
        try {
          child.stdin.writeln('crash');
          await child.stdin.close();
        } catch (_) {}
        await output.cancel();
        try {
          await child.exitCode.timeout(const Duration(seconds: 10));
        } on TimeoutException {
          child.kill();
          await child.exitCode;
        }
      }
    });
  }
}
