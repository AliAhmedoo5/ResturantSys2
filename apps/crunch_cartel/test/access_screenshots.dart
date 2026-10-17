import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> loadAccessFonts() async {
  if (Platform.isWindows) {
    final loader = FontLoader('Segoe UI');
    for (final name in ['segoeui.ttf', 'segoeuib.ttf', 'seguisb.ttf']) {
      loader.addFont(File('${Platform.environment['WINDIR']}/Fonts/$name').readAsBytes().then(ByteData.sublistView));
    }
    await loader.load();
  }
  final icons = FontLoader('MaterialIcons');
  icons.addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
  await icons.load();
}

Future<void> captureAccess(WidgetTester tester, GlobalKey key, String stage, double dpi) async {
  if (Platform.environment['CI'] != 'true') return;
  await tester.runAsync(() async {
    final boundary = key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: dpi);
    try {
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      final folder = await Directory('build/preview-screenshots').create(recursive: true);
      await File('${folder.path}/access-$stage-$dpi.png').writeAsBytes(data!.buffer.asUint8List());
    } finally { image.dispose(); }
  });
}
