import 'dart:io';

import 'package:pos_domain/access_policy.dart';
import 'package:pos_domain/command_environment.dart';
import 'package:pos_security/installation_key_store.dart';
import 'package:pos_security/pin_security.dart';
import 'package:pos_security/windows_private_storage.dart';

import 'authentication_service.dart';
import 'migration_backup.dart';
import 'pos_database.dart';

final class AccessOverview {
  AccessOverview({
    required this.configured,
    required this.pendingKey,
    required this.storagePath,
    required this.backupPath,
    required List<StaffIdentity> profiles,
  }) : profiles = List.unmodifiable(profiles);
  final bool configured, pendingKey;
  final String storagePath, backupPath;
  final List<StaffIdentity> profiles;
}

final class RecoveryInformation {
  const RecoveryInformation({this.code, this.envelope});
  final String? code, envelope;
  bool get alreadySaved => code == null;
  @override
  String toString() => 'RecoveryInformation(redacted)';
}

final class WorkspaceAccess {
  const WorkspaceAccess(this.staff, {required this.hasEnabledCashier});
  final StaffIdentity staff;
  final bool hasEnabledCashier;
}

final class AccessStorageFailure implements Exception {
  const AccessStorageFailure();
  @override
  String toString() =>
      'Installation storage needs recovery. Existing files were not replaced.';
}

/// Serial application boundary. The controller awaits each operation before
/// starting another or closing. Tokens, key handles and SQL never reach widgets.
abstract interface class AccessRepository {
  Future<AccessOverview> open();
  Future<RecoveryInformation> prepareRecovery();
  Future<AccessOverview> finishSetup({
    required String managerName,
    required String managerPin,
    required String managerConfirmation,
    required String cashierName,
    required String cashierPin,
    required String cashierConfirmation,
    required bool recoveryAcknowledged,
  });
  Future<WorkspaceAccess> signIn({
    required String staffId,
    required String pin,
  });
  Future<WorkspaceAccess> workspace({bool recordActivity = false});
  Future<void> lock();
  Future<void> close();
}

final class WindowsAccessRepository implements AccessRepository {
  WindowsAccessRepository({this.parent, CommandClock? clock})
    : clock = clock ?? const SystemCommandClock();
  final Directory? parent;
  final CommandClock clock;
  final RecordIdSource _ids = SecureRecordIdSource();
  WindowsPrivateStorage? _storage;
  PosDatabase? _database;
  LoadedInstallationKey? _key;
  PreparedInstallationKey? _prepared;
  AuthenticationService? _auth;
  AuthenticatedSession? _session;
  String? _terminal, _intent;
  bool _configured = false;
  static const databaseName = 'crunch-cartel.db';

  InstallationKeyStore get _store =>
      InstallationKeyStore.privateStorage(_storage!);
  Directory get _backups =>
      Directory.fromUri(_storage!.directory.uri.resolve('backups/'));

  @override
  Future<AccessOverview> open() async {
    await close();
    try {
      _storage = parent == null
          ? WindowsPrivateStorage.open()
          : WindowsPrivateStorage.provisionIn(parent!);
      final file = File.fromUri(_storage!.directory.uri.resolve(databaseName));
      final keyFile = File.fromUri(
        _storage!.directory.uri.resolve(InstallationKeyStore.fileName),
      );
      final keyExists =
          await FileSystemEntity.type(keyFile.path, followLinks: false) !=
          FileSystemEntityType.notFound;
      if (keyExists && !await file.exists()) throw const AccessStorageFailure();
      final backupType = await FileSystemEntity.type(
        _backups.path,
        followLinks: false,
      );
      if (backupType == FileSystemEntityType.notFound) await _backups.create();
      // Resolve the verified parent first: Windows temp/known-folder paths may
      // contain legitimate 8.3 aliases. Resolve only the child on the other side
      // so a redirected backup child still fails the comparison.
      final canonicalParent = Directory(await _storage!.directory.resolveSymbolicLinks());
      final expectedBackup = Directory.fromUri(canonicalParent.uri.resolve('backups/'));
      if (await FileSystemEntity.type(_backups.path, followLinks: false) !=
              FileSystemEntityType.directory ||
          _normalizedPath(await _backups.resolveSymbolicLinks()) !=
              _normalizedPath(expectedBackup.path)) {
        throw const AccessStorageFailure();
      }
      _database = await PosDatabase.open(
        file,
        migrationBackup: MigrationBackup(
          directory: _backups,
          appVersion: '0.3.0',
        ),
      );
      final installation = await _database!
          .customSelect(
            'SELECT * FROM installation_security WHERE singleton = 1',
          )
          .getSingleOrNull();
      if (installation != null) {
        _key = await _store.load(
          expectedKeyId: installation.read<String>('key_id'),
        );
        _terminal = installation.read<String>('terminal_id');
        _configured = true;
        _bindAuthentication();
      } else {
        if ((await _database!
                .customSelect('SELECT id FROM staff_credentials LIMIT 1')
                .get())
            .isNotEmpty) {
          throw const AccessStorageFailure();
        }
        if (keyExists) _key = await _store.loadPendingSetup();
        _terminal = _ids.nextId();
        _intent = _ids.nextId();
      }
      return await _overview();
    } catch (_) {
      await close();
      rethrow;
    }
  }

  @override
  Future<RecoveryInformation> prepareRecovery() async {
    _verify();
    if (_configured) throw const OnboardingConflict();
    if (_key != null) return const RecoveryInformation();
    _prepared ??= await PreparedInstallationKey.create();
    return RecoveryInformation(
      code: _prepared!.recoveryCode,
      envelope: _prepared!.recoveryEnvelope,
    );
  }

  @override
  Future<AccessOverview> finishSetup({
    required String managerName,
    required String managerPin,
    required String managerConfirmation,
    required String cashierName,
    required String cashierPin,
    required String cashierConfirmation,
    required bool recoveryAcknowledged,
  }) async {
    _verify();
    if (_configured) throw const OnboardingConflict();
    if (!recoveryAcknowledged)
      throw StateError('Save and acknowledge recovery information first.');
    for (final name in [managerName, cashierName]) {
      if (name.trim().isEmpty ||
          name.trim().length > 100 ||
          name.contains('\u0000'))
        throw ArgumentError('Enter a staff name of 1–100 characters.');
    }
    PinSecurity.validate(managerPin);
    PinSecurity.validate(cashierPin, primaryCashier: true);
    if (managerPin != managerConfirmation || cashierPin != cashierConfirmation)
      throw ArgumentError('PIN confirmation does not match.');
    if (managerPin == cashierPin) throw const DuplicatePin();
    if (_key == null) {
      final prepared = _prepared;
      if (prepared == null)
        throw StateError('Prepare recovery information first.');
      try {
        await _store.initialize(prepared);
      } on InstallationKeyExists {
        // A previous publication may have completed before its acknowledgement.
        // Accept only this operation's key, never an unrelated replacement.
      }
      _key = await _store.load(expectedKeyId: prepared.keyId);
    }
    _bindAuthentication();
    await _auth!.initialize(
      intentKey: _intent!,
      managerName: managerName,
      managerPin: managerPin,
      managerConfirmation: managerConfirmation,
      cashierName: cashierName,
      cashierPin: cashierPin,
      cashierConfirmation: cashierConfirmation,
      recoveryAcknowledged: true,
    );
    _configured = true;
    _prepared = null;
    return _overview();
  }

  @override
  Future<WorkspaceAccess> signIn({
    required String staffId,
    required String pin,
  }) async {
    _verify();
    if (!_configured || _session != null) throw const AuthenticationRejected();
    _session = await _auth!.signIn(staffId: staffId, pin: pin);
    return workspace();
  }

  @override
  Future<WorkspaceAccess> workspace({bool recordActivity = false}) async {
    _verify();
    final session = _session;
    if (session == null) throw const AuthenticationRejected();
    final staff = recordActivity
        ? await _auth!.authorize(session.token, Capability.lockOwnSession)
        : await _auth!.inspectSession(session.token);
    final overview = await _overview();
    return WorkspaceAccess(
      staff,
      hasEnabledCashier: overview.profiles.any(
        (staff) => staff.role == StaffRole.cashier,
      ),
    );
  }

  @override
  Future<void> lock() async {
    final session = _session;
    _session = null;
    if (session == null) return;
    _verify();
    try {
      await _auth!.lockSession(session.token);
    } on AuthenticationRejected {
      // Already expired or invalidated; the local bearer is still discarded.
    }
  }

  Future<AccessOverview> _overview() async {
    final rows = await _database!
        .customSelect(
          'SELECT id, display_name, role FROM staff_credentials WHERE enabled = 1 ORDER BY role DESC, display_name, id',
        )
        .get();
    return AccessOverview(
      configured: _configured,
      pendingKey: !_configured && _key != null,
      storagePath: _storage!.directory.path,
      backupPath: _backups.path,
      profiles: rows
          .map(
            (row) => StaffIdentity(
              row.read<String>('id'),
              row.read<String>('display_name'),
              StaffRole.values.byName(row.read<String>('role')),
            ),
          )
          .toList(),
    );
  }

  void _verify() {
    if (_database == null || _storage == null)
      throw const AccessStorageFailure();
    _storage!.verify();
  }

  String _normalizedPath(String path) => path
      .replaceAll('/', r'\')
      .replaceAll(RegExp(r'[\\]+$'), '')
      .toLowerCase();

  void _bindAuthentication() {
    _auth = AuthenticationService(
      database: _database!,
      key: _key!,
      terminalId: _terminal!,
      clock: clock,
    );
  }

  @override
  Future<void> close() async {
    _session = null;
    _auth = null;
    _prepared = null;
    _key?.dispose();
    _key = null;
    final database = _database;
    _database = null;
    await database?.close();
    _storage = null;
    _terminal = null;
    _intent = null;
    _configured = false;
  }
}
