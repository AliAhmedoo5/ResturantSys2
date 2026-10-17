import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_data/pos_data.dart';

final accessRepositoryProvider = Provider<AccessRepository>((ref) => WindowsAccessRepository());
final accessControllerProvider = Provider<AccessController>((ref) {
  final controller = AccessController(ref.watch(accessRepositoryProvider));
  ref.onDispose(controller.dispose);
  return controller;
});

enum AccessStage { loading, storageError, recovery, accounts, login, workspace }

class AccessController extends ChangeNotifier {
  AccessController(this.repository);
  final AccessRepository repository;
  AccessStage stage = AccessStage.loading;
  AccessOverview? overview;
  RecoveryInformation? recovery;
  WorkspaceAccess? workspace;
  String? error;
  bool busy = false, acknowledged = false;
  bool _disposed = false, _started = false, _lockRequested = false;
  Timer? _timer;
  Future<void>? _operation;
  DateTime? _lastActivity;

  Future<void> start() async {
    if (_started) return;
    _started = true;
    await _run(() async {
      overview = await repository.open();
      stage = overview!.configured ? AccessStage.login : AccessStage.recovery;
    }, storageFailure: true);
    if (!_disposed) _timer = Timer.periodic(const Duration(seconds: 15), (_) => inspect());
  }

  Future<void> prepareRecovery() => _run(() async {
    recovery = await repository.prepareRecovery();
  });

  void acknowledge(bool value) {
    if (busy || recovery == null) return;
    acknowledged = value;
    notifyListeners();
  }

  void continueSetup() {
    if (busy || !acknowledged || recovery == null) return;
    recovery = null;
    stage = AccessStage.accounts;
    notifyListeners();
  }

  Future<void> finishSetup({required String managerName, required String managerPin,
    required String managerConfirmation, required String cashierName,
    required String cashierPin, required String cashierConfirmation}) => _run(() async {
    overview = await repository.finishSetup(managerName: managerName, managerPin: managerPin,
      managerConfirmation: managerConfirmation, cashierName: cashierName,
      cashierPin: cashierPin, cashierConfirmation: cashierConfirmation,
      recoveryAcknowledged: acknowledged);
    stage = AccessStage.login;
  });

  Future<void> signIn(String staffId, String pin) => _run(() async {
    workspace = await repository.signIn(staffId: staffId, pin: pin);
    stage = AccessStage.workspace;
    _lastActivity = null;
  });

  Future<void> inspect({bool activity = false}) async {
    if (stage != AccessStage.workspace || busy || _disposed) return;
    if (activity) {
      final now = DateTime.now();
      if (_lastActivity != null && now.difference(_lastActivity!) < const Duration(seconds: 30)) return;
      _lastActivity = now;
    }
    await _run(() async { workspace = await repository.workspace(recordActivity: activity); }, quiet: true);
  }

  /// Hide private state synchronously, including when Argon2/login is in flight.
  /// The serial operation's finally block revokes any subsequently issued token.
  void lock() {
    if (_disposed) return;
    _lockRequested = true;
    workspace = null;
    recovery = null;
    if (overview?.configured == true) stage = AccessStage.login;
    if (stage == AccessStage.recovery) acknowledged = false;
    notifyListeners();
    if (!busy) unawaited(_run(() async {}));
  }

  Future<void> _run(Future<void> Function() action, {bool storageFailure = false, bool quiet = false}) async {
    if (busy || _disposed) return;
    busy = true;
    error = null;
    if (!quiet) notifyListeners();
    final done = Completer<void>();
    _operation = done.future;
    try {
      await action();
    } on AuthenticationRejected {
      _lockRequested = true;
      error = 'Session expired or credentials were not accepted. Sign in again.';
    } on AuthenticationThrottled {
      error = 'Too many attempts. Wait 15 minutes before trying again.';
    } on DuplicatePin {
      error = 'Choose another PIN.';
    } on ArgumentError {
      error = 'Check names and PINs. Manager: 4–8 digits. Cashier: 4 digits. Confirm both PINs.';
    } catch (_) {
      error = 'Unable to complete this step. Existing data was preserved. Close and reopen the application; contact support if this continues.';
      if (storageFailure || stage == AccessStage.workspace) stage = AccessStage.storageError;
      _lockRequested = true;
    } finally {
      if (_lockRequested || _disposed) {
        workspace = null;
        recovery = null;
        try { await repository.lock(); } catch (_) {
          error = 'Storage protection could not be verified. Close the application and contact support.';
          stage = AccessStage.storageError;
        }
        if (stage != AccessStage.storageError && overview?.configured == true) stage = AccessStage.login;
        _lockRequested = false;
      }
      busy = false;
      done.complete();
      if (!_disposed) notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    recovery = null;
    workspace = null;
    unawaited(_close());
    super.dispose();
  }
  Future<void> _close() async {
    await _operation;
    try { await repository.lock(); } catch (_) { /* Local state is already hidden. */ }
    try { await repository.close(); } catch (_) { /* No automatic reset or repair. */ }
  }
}
