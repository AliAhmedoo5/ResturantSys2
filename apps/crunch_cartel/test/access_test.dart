import 'dart:async';
import 'package:crunch_cartel/app/app.dart';
import 'package:crunch_cartel/features/access/access_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_data/pos_data.dart';
import 'package:pos_domain/access_policy.dart';

final class FixtureRepository implements AccessRepository {
  bool configured = false, locked = true, expired = false, closed = false;
  int setupCount = 0, activityCount = 0;
  Completer<void>? loginGate;
  StaffIdentity? signedIn;
  static const profiles = [StaffIdentity('manager', 'Manager Fixture', StaffRole.manager), StaffIdentity('cashier', 'Cashier Fixture', StaffRole.cashier)];
  AccessOverview get overview => AccessOverview(configured: configured, pendingKey: false, storagePath: r'C:\Fixture\CrunchCartel', backupPath: r'C:\Fixture\CrunchCartel\backups', profiles: configured ? profiles : []);
  @override
  Future<AccessOverview> open() async => overview;
  @override
  Future<RecoveryInformation> prepareRecovery() async => const RecoveryInformation(code: 'TEST-ONLY-CODE', envelope: 'TEST-ONLY-ENVELOPE');
  @override
  Future<AccessOverview> finishSetup({required String managerName, required String managerPin, required String managerConfirmation, required String cashierName, required String cashierPin, required String cashierConfirmation, required bool recoveryAcknowledged}) async {
    if (!recoveryAcknowledged || cashierPin.length != 4) throw ArgumentError();
    configured = true;
    setupCount++;
    return overview;
  }
  @override
  Future<WorkspaceAccess> signIn({required String staffId, required String pin}) async {
    await loginGate?.future;
    signedIn = profiles.singleWhere((staff) => staff.id == staffId);
    locked = false;
    return workspace();
  }
  @override
  Future<WorkspaceAccess> workspace({bool recordActivity = false}) async {
    if (expired || locked) throw const AuthenticationRejected();
    if (recordActivity) activityCount++;
    return WorkspaceAccess(signedIn!, hasEnabledCashier: true);
  }
  @override
  Future<void> lock() async { locked = true; }
  @override
  Future<void> close() async { closed = true; }
}

void main() {
  test('background validation never records activity and expiry removes workspace', () async {
    final repository = FixtureRepository()..configured = true;
    final controller = AccessController(repository);
    await controller.start();
    await controller.signIn('manager', '1234');
    await controller.inspect();
    expect(repository.activityCount, 0);
    await controller.inspect(activity: true);
    expect(repository.activityCount, 1);
    repository.expired = true;
    await controller.inspect();
    expect(controller.stage, AccessStage.login);
    expect(controller.workspace, isNull);
    expect(repository.locked, true);
    controller.dispose();
  });

  test('focus loss during login revokes the late token before showing workspace', () async {
    final repository = FixtureRepository()..configured = true..loginGate = Completer<void>();
    final controller = AccessController(repository);
    await controller.start();
    final signingIn = controller.signIn('manager', '1234');
    controller.lock();
    repository.loginGate!.complete();
    await signingIn;
    expect(controller.workspace, isNull);
    expect(controller.stage, AccessStage.login);
    expect(repository.locked, true);
    controller.dispose();
  });

  for (final dpi in [1.0, 1.25, 1.5]) {
    testWidgets('setup and separate role access at $dpi DPI', (tester) async {
      tester.view.physicalSize = const Size(1366, 768);
      tester.view.devicePixelRatio = dpi;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final repository = FixtureRepository();
      await tester.pumpWidget(ProviderScope(overrides: [accessRepositoryProvider.overrideWithValue(repository)], child: const CrunchCartelApp()));
      await tester.pumpAndSettle();
      expect(find.text('Make this your restaurant.'), findsOneWidget);
      var next = find.widgetWithText(FilledButton, 'Continue to staff profiles');
      expect(tester.widget<FilledButton>(next).onPressed, isNull);
      await tester.ensureVisible(find.text('Prepare recovery kit'));
      await tester.tap(find.text('Prepare recovery kit'));
      await tester.pumpAndSettle();
      expect(find.textContaining('TEST-ONLY-CODE'), findsNothing);
      await tester.ensureVisible(find.byType(CheckboxListTile));
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pumpAndSettle();
      await tester.ensureVisible(next);
      await tester.tap(next);
      await tester.pumpAndSettle();
      expect(find.text('Create your primary Cashier counter profile and 4-digit PIN.'), findsOneWidget);
      Future<void> fill(String label, String text) async {
        final field = find.widgetWithText(TextField, label);
        await tester.ensureVisible(field);
        await tester.enterText(field, text);
      }
      await fill('Manager name', 'Manager Fixture');
      await fill('Manager PIN (4–8 digits)', '724915');
      await fill('Confirm Manager PIN', '724915');
      await fill('Cashier name', 'Cashier Fixture');
      await fill('Cashier PIN (4 digits)', '0638');
      await fill('Confirm Cashier PIN', '0638');
      final create = find.text('Create profiles and continue to sign-in');
      await tester.ensureVisible(create);
      await tester.tap(create);
      await tester.pumpAndSettle();
      expect(repository.setupCount, 1);
      expect(repository.locked, true);
      expect(find.text('Your shift starts with you.'), findsOneWidget);
      await fill('PIN', '724915');
      await tester.ensureVisible(find.text('Sign in'));
      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();
      expect(find.text('MANAGER • Restaurant readiness'), findsOneWidget);
      expect(find.textContaining('Billing unavailable'), findsNothing);
      await tester.ensureVisible(find.text('Switch to Cashier'));
      await tester.tap(find.text('Switch to Cashier'));
      await tester.pumpAndSettle();
      expect(repository.locked, true);
      expect(find.text('Your shift starts with you.'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    });
  }
}
