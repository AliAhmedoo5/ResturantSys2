import 'dart:io';
import 'dart:ui' as ui;

import 'package:crunch_cartel/app/app.dart';
import 'package:crunch_cartel/app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    if (Platform.isWindows) {
      final loader = FontLoader('Segoe UI');
      for (final name in ['segoeui.ttf', 'segoeuib.ttf', 'seguisb.ttf']) {
        final file = File('${Platform.environment['WINDIR']}/Fonts/$name');
        loader.addFont(file.readAsBytes().then(ByteData.sublistView));
      }
      await loader.load();
    }
  });
  testWidgets('navigation is preview-only and manager has no checkout', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1366, 768);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ProviderScope(child: CrunchCartelApp()));
    await tester.pumpAndSettle();
    expect(find.text('CRUNCH\nCARTEL'), findsNWidgets(2));
    expect(
      Theme.of(
        tester.element(find.text('Your counter. Under control.')),
      ).colorScheme.primary,
      CartelColors.yellow,
    );
    await tester.ensureVisible(find.text('Preview management'));
    await tester.tap(find.text('Preview management'));
    await tester.pumpAndSettle();
    expect(find.text('See the whole restaurant.'), findsOneWidget);
    expect(find.text('Checkout unavailable'), findsNothing);
    expect(find.text('Counter'), findsNothing);
    await tester.tap(find.text('Welcome'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Preview counter'));
    await tester.tap(find.text('Preview counter'));
    await tester.pumpAndSettle();
    final checkout = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Checkout unavailable'),
    );
    expect(checkout.onPressed, isNull);
    await tester.sendKeyEvent(LogicalKeyboardKey.f1);
    await tester.pumpAndSettle();
    expect(find.text('Keyboard shortcuts'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Keyboard shortcuts'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final dpi in [1.0, 1.25, 1.5]) {
    testWidgets('all preview routes fit 1366x768 at $dpi scale', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1366, 768);
      tester.view.devicePixelRatio = dpi;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final boundaryKey = GlobalKey();
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: RepaintBoundary(
            key: boundaryKey,
            child: const CrunchCartelApp(),
          ),
        ),
      );
      for (final route in [
        '/',
        '/preview/counter',
        '/preview/manager',
        '/setup',
      ]) {
        container.read(routerProvider).go(route);
        await tester.pumpAndSettle();
        expect(
          tester.takeException(),
          isNull,
          reason: 'Layout overflow at $route / $dpi',
        );
        if (Platform.environment['CI'] == 'true') {
          final boundary =
              boundaryKey.currentContext!.findRenderObject()!
                  as RenderRepaintBoundary;
          await tester.runAsync(() async {
            final image = await boundary.toImage(pixelRatio: dpi);
            final bytes = await image.toByteData(
              format: ui.ImageByteFormat.png,
            );
            final name = route == '/' ? 'welcome' : route.replaceAll('/', '-');
            final folder = Directory('build/preview-screenshots')
              ..createSync(recursive: true);
            await File(
              '${folder.path}/$name-$dpi.png',
            ).writeAsBytes(bytes!.buffer.asUint8List());
            image.dispose();
          });
        }
      }
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}
