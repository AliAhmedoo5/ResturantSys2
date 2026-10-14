import 'dart:convert';
import 'dart:io';

import 'package:pos_data/pos_data.dart';

Future<void> main(List<String> arguments) async {
  try {
    final database = await PosDatabase.open(File(arguments.single));
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
