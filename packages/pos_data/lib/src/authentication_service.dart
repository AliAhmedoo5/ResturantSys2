import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:pos_domain/access_policy.dart';
import 'package:pos_domain/command_environment.dart';
import 'package:pos_security/installation_key_store.dart';
import 'package:pos_security/pin_security.dart';

import 'command_coordinator.dart';
import 'pos_database.dart';

final class AuthenticationRejected implements Exception {
  const AuthenticationRejected();
  @override
  String toString() => 'Unable to sign in with these credentials.';
}

final class AuthenticationThrottled implements Exception {
  const AuthenticationThrottled();
  @override
  String toString() => 'Too many attempts. Wait before trying again.';
}

final class OnboardingConflict implements Exception {
  const OnboardingConflict();
  @override
  String toString() => 'Setup is already complete or its retry details differ.';
}

final class DuplicatePin implements Exception {
  const DuplicatePin();
  @override
  String toString() => 'Choose another PIN';
}

final class StaffIdentity {
  const StaffIdentity(this.id, this.displayName, this.role);
  final String id, displayName;
  final StaffRole role;
}

final class SetupReceipt {
  const SetupReceipt(this.managerId, this.cashierId);
  final String managerId, cashierId;
}

/// Keep in process memory only; never persist the bearer token in UI settings.
final class AuthenticatedSession {
  const AuthenticatedSession._(this.id, this.token, this.staff);
  final String id, token;
  final StaffIdentity staff;
  @override
  String toString() => 'AuthenticatedSession(redacted)';
}

/// Internal application service, not a public network endpoint. The terminal ID
/// is installation configuration, never supplied by a login form. PIN checking
/// happens only after a committed attempt reservation, outside a SQL transaction.
final class AuthenticationService {
  AuthenticationService({
    required this.database,
    required this.key,
    required this.terminalId,
    CommandClock? clock,
    RecordIdSource? ids,
  }) : clock = clock ?? const SystemCommandClock(),
       ids = ids ?? SecureRecordIdSource() {
    _identifier(terminalId);
  }
  final PosDatabase database;
  final LoadedInstallationKey key;
  final String terminalId;
  final CommandClock clock;
  final RecordIdSource ids;

  // Conservative initial policy, shared by all service instances and persisted
  // windows. A future audited Manager settings command may make it configurable.
  static const attemptWindow = Duration(minutes: 15);
  static const accountAttemptLimit = 5;
  static const deviceAttemptLimit = 20;
  static const idleTimeout = Duration(minutes: 5);
  static const maximumSessionLifetime = Duration(hours: 12);

  Future<SetupReceipt> initialize({
    required String intentKey,
    required String managerName,
    required String managerPin,
    required String managerConfirmation,
    required String cashierName,
    required String cashierPin,
    required String cashierConfirmation,
    required bool recoveryAcknowledged,
  }) async {
    _outsideTransaction();
    _identifier(intentKey);
    _name(managerName);
    _name(cashierName);
    if (!recoveryAcknowledged)
      throw StateError('Secure and acknowledge the recovery code first.');
    PinSecurity.validate(managerPin);
    PinSecurity.validate(cashierPin, primaryCashier: true);
    if (managerPin != managerConfirmation ||
        cashierPin != cashierConfirmation) {
      throw ArgumentError('PIN confirmation does not match.');
    }
    final managerFingerprint = await key.fingerprint(managerPin);
    final cashierFingerprint = await key.fingerprint(cashierPin);
    if (managerFingerprint == cashierFingerprint) throw const DuplicatePin();
    final hash = _hash(
      jsonEncode([
        terminalId,
        key.keyId,
        managerName.trim(),
        managerFingerprint,
        cashierName.trim(),
        cashierFingerprint,
      ]),
    );
    final previous = await _installation();
    if (previous != null) return _setupRetry(previous, intentKey, hash);
    final managerVerifier = await PinSecurity.createVerifier(managerPin);
    final cashierVerifier = await PinSecurity.createVerifier(
      cashierPin,
      primaryCashier: true,
    );
    return database.transaction(() async {
      final previous = await _installation();
      if (previous != null) return _setupRetry(previous, intentKey, hash);
      if ((await database
              .customSelect('SELECT id FROM staff_credentials LIMIT 1')
              .get())
          .isNotEmpty) {
        throw const OnboardingConflict();
      }
      final now = _now();
      final manager = ids.nextId(), cashier = ids.nextId();
      await _insertStaff(
        manager,
        managerName.trim(),
        StaffRole.manager,
        managerFingerprint,
        managerVerifier,
      );
      await _insertStaff(
        cashier,
        cashierName.trim(),
        StaffRole.cashier,
        cashierFingerprint,
        cashierVerifier,
      );
      await database.customStatement(
        'INSERT INTO installation_security VALUES (1, ?, ?, ?, ?, ?, ?, ?)',
        [key.keyId, terminalId, intentKey, hash, manager, cashier, now],
      );
      await _event('onboarding_completed', now, staffId: manager);
      return SetupReceipt(manager, cashier);
    });
  }

  Future<AuthenticatedSession> signIn({
    required String staffId,
    required String pin,
  }) async {
    _outsideTransaction();
    _identifier(staffId);
    final reservation = await database.transaction(() async {
      await _requireInstallation();
      final now = _now();
      final staff = await _staff(staffId);
      final deviceWindow = await _reserve(
        'device',
        terminalId,
        deviceAttemptLimit,
        now,
      );
      // Unknown IDs consume the same device budget, but cannot grow arbitrary
      // per-account rows. Disabled accounts retain their attempt budget.
      final accountWindow = staff == null
          ? null
          : await _reserve('account', staffId, accountAttemptLimit, now);
      await _event(
        'login_attempt_reserved',
        now,
        staffId: staff?.read<String>('id'),
      );
      return (
        staff: staff,
        deviceWindow: deviceWindow,
        accountWindow: accountWindow,
        at: now,
      );
    });
    final staff = reservation.staff;
    var matches = false;
    try {
      final record = staff == null
          ? PinVerifierRecord(
              saltBase64: base64Encode(List.filled(16, 0)),
              hashBase64: base64Encode(List.filled(32, 0)),
            )
          : PinVerifierRecord(
              saltBase64: staff.read<String>('salt_base64'),
              hashBase64: staff.read<String>('hash_base64'),
              formatVersion: staff.read<int>('verifier_version'),
            );
      matches = await PinSecurity.verify(pin, record);
    } on ArgumentError {
      matches = false;
    } on FormatException {
      matches = false;
    }
    // Throw only AFTER committing denial evidence; failed attempts and crashes
    // retain reservations. Never roll back the attempt counter on bad credentials.
    final session = await database.transaction<AuthenticatedSession?>(() async {
      await _requireInstallation();
      final now = _now();
      final current = await _staff(staffId);
      if (!matches ||
          staff == null ||
          current == null ||
          current.read<int>('enabled') != 1 ||
          current.read<int>('revision') != staff.read<int>('revision') ||
          current.read<String>('role') != staff.read<String>('role') ||
          current.read<String>('hash_base64') !=
              staff.read<String>('hash_base64') ||
          now < reservation.at ||
          now - reservation.at >= attemptWindow.inMilliseconds) {
        await _event('login_failed', now, staffId: current?.read<String>('id'));
        return null;
      }
      final id = ids.nextId();
      final token = '${ids.nextId()}${ids.nextId()}';
      final role = StaffRole.values.byName(current.read<String>('role'));
      await database.customStatement(
        'INSERT INTO auth_sessions VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 0)',
        [
          id,
          _hash(token),
          staffId,
          current.read<int>('revision'),
          role.name,
          terminalId,
          now,
          now,
          now + maximumSessionLifetime.inMilliseconds,
        ],
      );
      await _release('device', terminalId, reservation.deviceWindow);
      await _release('account', staffId, reservation.accountWindow!);
      await _event('login_succeeded', now, staffId: staffId, sessionId: id);
      return AuthenticatedSession._(
        id,
        token,
        StaffIdentity(staffId, current.read<String>('display_name'), role),
      );
    });
    if (session == null) throw const AuthenticationRejected();
    return session;
  }

  /// Call inside the command coordinator authorization callback so permission,
  /// revision and transaction writes share the same database transaction.
  Future<StaffIdentity> authorize(
    String token,
    Capability capability, {
    bool riderOperationsEnabled = false,
  }) => database.transaction(() async {
    final session = await _currentSession(token);
    final role = StaffRole.values.byName(session.read<String>('role'));
    AccessPolicy.require(
      role,
      capability,
      riderOperationsEnabled: riderOperationsEnabled,
    );
    await database.customStatement(
      'UPDATE auth_sessions SET last_seen_ms = ? WHERE id = ?',
      [_now(), session.read<String>('id')],
    );
    return StaffIdentity(
      session.read<String>('staff_id'),
      session.read<String>('display_name'),
      role,
    );
  });

  Future<void> authorizeCommand(
    String token,
    CommandIntent intent,
    Capability capability, {
    bool riderOperationsEnabled = false,
  }) async {
    if (!database.isInsideTransaction)
      throw StateError('Command authorization requires its transaction.');
    final session = await _currentSession(token);
    if (intent.actorId != session.read<String>('staff_id') ||
        intent.sessionId != session.read<String>('id')) {
      throw const AuthenticationRejected();
    }
    await authorize(
      token,
      capability,
      riderOperationsEnabled: riderOperationsEnabled,
    );
  }

  Future<void> lockSession(String token) => database.transaction(() async {
    final session = await _currentSession(token);
    await database.customStatement(
      'UPDATE auth_sessions SET revoked = 1 WHERE id = ?',
      [session.read<String>('id')],
    );
    await _event(
      'session_locked',
      _now(),
      staffId: session.read<String>('staff_id'),
      sessionId: session.read<String>('id'),
    );
  });

  Future<QueryRow> _currentSession(String token) async {
    await _requireInstallation();
    if (token.isEmpty || token.length > 256)
      throw const AuthenticationRejected();
    final row = await database
        .customSelect(
          '''SELECT s.*, c.display_name, c.role, c.enabled, c.revision
      FROM auth_sessions s JOIN staff_credentials c ON c.id = s.staff_id WHERE s.token_hash = ?''',
          variables: [Variable(_hash(token))],
        )
        .getSingleOrNull();
    final now = _now();
    if (row == null ||
        row.read<int>('revoked') != 0 ||
        row.read<int>('enabled') != 1 ||
        row.read<String>('terminal_id') != terminalId ||
        row.read<int>('credential_revision') != row.read<int>('revision') ||
        row.read<String>('role_at_issue') != row.read<String>('role') ||
        now < row.read<int>('last_seen_ms') ||
        now >= row.read<int>('expires_at_ms') ||
        now - row.read<int>('last_seen_ms') >= idleTimeout.inMilliseconds)
      throw const AuthenticationRejected();
    return row;
  }

  Future<int> _reserve(String scope, String subject, int limit, int now) async {
    final row = await database
        .customSelect(
          'SELECT * FROM auth_attempt_limits WHERE scope = ? AND subject_id = ?',
          variables: [Variable(scope), Variable(subject)],
        )
        .getSingleOrNull();
    if (row != null && now < row.read<int>('last_seen_ms'))
      throw const AuthenticationThrottled();
    final expired =
        row == null ||
        now - row.read<int>('window_start_ms') >= attemptWindow.inMilliseconds;
    final window = expired ? now : row.read<int>('window_start_ms');
    final count = expired ? 0 : row.read<int>('reserved_count');
    if (count >= limit) throw const AuthenticationThrottled();
    await database.customStatement(
      '''INSERT INTO auth_attempt_limits VALUES (?, ?, ?, ?, ?)
      ON CONFLICT(scope, subject_id) DO UPDATE SET window_start_ms = excluded.window_start_ms,
      last_seen_ms = excluded.last_seen_ms, reserved_count = excluded.reserved_count''',
      [scope, subject, window, now, count + 1],
    );
    return window;
  }

  Future<void> _release(
    String scope,
    String subject,
    int window,
  ) => database.customStatement(
    'UPDATE auth_attempt_limits SET reserved_count = reserved_count - 1 WHERE scope = ? AND subject_id = ? AND window_start_ms = ? AND reserved_count > 0',
    [scope, subject, window],
  );

  Future<void> _insertStaff(
    String id,
    String name,
    StaffRole role,
    String fingerprint,
    PinVerifierRecord verifier,
  ) => database.customStatement(
    'INSERT INTO staff_credentials VALUES (?, ?, ?, 1, 1, ?, ?, ?, ?)',
    [
      id,
      name,
      role.name,
      fingerprint,
      verifier.saltBase64,
      verifier.hashBase64,
      verifier.formatVersion,
    ],
  );

  Future<void> _event(
    String kind,
    int now, {
    String? staffId,
    String? sessionId,
  }) => database.customStatement(
    'INSERT INTO security_events VALUES (?, ?, ?, ?, ?, ?)',
    [ids.nextId(), kind, staffId, sessionId, terminalId, now],
  );

  Future<QueryRow?> _staff(String id) => database
      .customSelect(
        'SELECT * FROM staff_credentials WHERE id = ?',
        variables: [Variable(id)],
      )
      .getSingleOrNull();
  Future<QueryRow?> _installation() => database
      .customSelect('SELECT * FROM installation_security WHERE singleton = 1')
      .getSingleOrNull();
  Future<void> _requireInstallation() async {
    final row = await _installation();
    if (row == null ||
        row.read<String>('key_id') != key.keyId ||
        row.read<String>('terminal_id') != terminalId) {
      throw const AuthenticationRejected();
    }
  }

  SetupReceipt _setupRetry(QueryRow row, String intent, String hash) {
    if (row.read<String>('setup_intent') != intent ||
        row.read<String>('setup_hash') != hash ||
        row.read<String>('key_id') != key.keyId ||
        row.read<String>('terminal_id') != terminalId)
      throw const OnboardingConflict();
    return SetupReceipt(
      row.read<String>('first_manager_id'),
      row.read<String>('primary_cashier_id'),
    );
  }

  int _now() {
    final now = clock.nowUtc();
    if (!now.isUtc || now.millisecondsSinceEpoch < 0)
      throw StateError('A valid UTC security clock is required.');
    return now.millisecondsSinceEpoch;
  }

  void _outsideTransaction() {
    if (database.isInsideTransaction)
      throw StateError(
        'Authentication requires an independently committed attempt budget.',
      );
  }
}

String _hash(String value) => sha256.convert(utf8.encode(value)).toString();
void _identifier(String value) {
  if (value.isEmpty || value.length > 128 || value.contains('\u0000'))
    throw ArgumentError('Invalid identifier.');
}

void _name(String value) {
  if (value.trim().isEmpty ||
      value.trim().length > 100 ||
      value.contains('\u0000'))
    throw ArgumentError('Invalid staff name.');
}
