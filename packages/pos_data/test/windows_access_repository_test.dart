@TestOn('windows')
library;

import 'dart:io';
import 'package:pos_data/pos_data.dart';
import 'package:pos_domain/access_policy.dart';
import 'package:pos_domain/command_environment.dart';
import 'package:pos_security/installation_key_store.dart';
import 'package:pos_security/windows_private_storage.dart';
import 'package:test/test.dart';

final class FixtureClock implements CommandClock {
  DateTime now = DateTime.utc(2026, 10, 17);
  @override
  DateTime nowUtc() => now;
}

void main() {
  late Directory parent;
  late WindowsAccessRepository repository;
  late FixtureClock clock;
  File stored(String name) => File('${parent.path}/CrunchCartel/$name');
  Future<AccessOverview> finish({bool acknowledged = true, String cashier = '0638'}) => repository.finishSetup(
    managerName: 'Fixture Manager', managerPin: '724915', managerConfirmation: '724915',
    cashierName: 'Fixture Cashier', cashierPin: cashier, cashierConfirmation: cashier,
    recoveryAcknowledged: acknowledged);
  Future<AccessOverview> setup() async {
    await repository.open();
    await repository.prepareRecovery();
    return finish();
  }
  setUp(() async {
    parent = await Directory.systemTemp.createTemp('cartel-access-');
    clock = FixtureClock();
    repository = WindowsAccessRepository(parent: parent, clock: clock);
  });
  tearDown(() async {
    await repository.close();
    await parent.delete(recursive: true);
  });

  test('fresh startup prepares recovery without publishing or creating accounts', () async {
    final state = await repository.open();
    expect(state.configured, false);
    expect(state.profiles, isEmpty);
    expect(await Directory(state.backupPath).exists(), true);
    final first = await repository.prepareRecovery();
    final second = await repository.prepareRecovery();
    expect(first.code, isNotEmpty);
    expect(second.code, first.code);
    expect(first.toString(), isNot(contains(first.code!)));
    expect(await stored(InstallationKeyStore.fileName).exists(), false);
    await expectLater(finish(acknowledged: false), throwsStateError);
    await expectLater(finish(cashier: '12345'), throwsArgumentError);
    expect(await stored(InstallationKeyStore.fileName).exists(), false);
  });

  test('setup, reopen, separate sign-in and lock use persistent Windows storage', () async {
    final created = await setup();
    expect(created.profiles.map((staff) => staff.role).toSet(), {StaffRole.manager, StaffRole.cashier});
    await expectLater(repository.workspace(), throwsA(isA<AuthenticationRejected>()));
    final bytes = await stored(InstallationKeyStore.fileName).readAsBytes();
    final reopened = await repository.open();
    expect(reopened.configured, true);
    expect(await stored(InstallationKeyStore.fileName).readAsBytes(), bytes);
    final manager = reopened.profiles.singleWhere((staff) => staff.role == StaffRole.manager);
    expect((await repository.signIn(staffId: manager.id, pin: '724915')).staff.role, StaffRole.manager);
    await repository.lock();
    await expectLater(repository.workspace(), throwsA(isA<AuthenticationRejected>()));
    final cashier = reopened.profiles.singleWhere((staff) => staff.role == StaffRole.cashier);
    expect((await repository.signIn(staffId: cashier.id, pin: '0638')).staff.role, StaffRole.cashier);
  });

  test('background inspection does not prevent idle expiry; activity extends it', () async {
    final state = await setup();
    final manager = state.profiles.singleWhere((staff) => staff.role == StaffRole.manager);
    await repository.signIn(staffId: manager.id, pin: '724915');
    clock.now = clock.now.add(const Duration(minutes: 4));
    await repository.workspace();
    clock.now = clock.now.add(const Duration(minutes: 1));
    await expectLater(repository.workspace(), throwsA(isA<AuthenticationRejected>()));
    await repository.lock();
    await repository.signIn(staffId: manager.id, pin: '724915');
    clock.now = clock.now.add(const Duration(minutes: 4));
    await repository.workspace(recordActivity: true);
    clock.now = clock.now.add(const Duration(minutes: 4));
    await repository.workspace();
    clock.now = clock.now.add(const Duration(minutes: 1));
    await expectLater(repository.workspace(), throwsA(isA<AuthenticationRejected>()));
  });

  test('missing established key fails without generating a replacement', () async {
    await setup();
    await repository.close();
    await stored(InstallationKeyStore.fileName).delete();
    await expectLater(repository.open(), throwsA(isA<FileSystemException>()));
    expect(await stored(InstallationKeyStore.fileName).exists(), false);
    expect(await stored(WindowsAccessRepository.databaseName).exists(), true);
  });

  test('orphan key cannot silently create a new database', () async {
    await setup();
    await repository.close();
    await stored(WindowsAccessRepository.databaseName).delete();
    final bytes = await stored(InstallationKeyStore.fileName).readAsBytes();
    await expectLater(repository.open(), throwsA(isA<AccessStorageFailure>()));
    expect(await stored(WindowsAccessRepository.databaseName).exists(), false);
    expect(await stored(InstallationKeyStore.fileName).readAsBytes(), bytes);
  });

  test('interrupted key publication resumes without replacing the recovery identity', () async {
    await repository.open();
    await repository.close();
    final storage = WindowsPrivateStorage.provisionIn(parent);
    final prepared = await PreparedInstallationKey.create();
    final store = InstallationKeyStore.privateStorage(storage);
    await store.initialize(prepared);
    final bytes = await stored(InstallationKeyStore.fileName).readAsBytes();
    expect((await repository.open()).pendingKey, true);
    expect((await repository.prepareRecovery()).alreadySaved, true);
    await expectLater(finish(acknowledged: false), throwsStateError);
    expect((await finish()).configured, true);
    expect(await stored(InstallationKeyStore.fileName).readAsBytes(), bytes);
  });

  test('damaged pending key is rejected without replacement', () async {
    await repository.open();
    await repository.close();
    await stored(InstallationKeyStore.fileName).writeAsString('{invalid');
    await expectLater(repository.open(), throwsA(isA<InstallationKeyInvalid>()));
    expect(await stored(InstallationKeyStore.fileName).readAsString(), '{invalid');
  });
}
