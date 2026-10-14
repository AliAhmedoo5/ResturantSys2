import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:pos_domain/command_environment.dart';

import 'pos_database.dart';

/// Internal service boundary, not a UI action or an authenticated session.
/// Payloads/snapshots must use an explicit allowlist of non-secret fields.
final class CommandIntent {
  CommandIntent({
    required this.key,
    required this.kind,
    required this.actorId,
    required this.sessionId,
    required this.entityType,
    required this.entityId,
    required this.expectedRevision,
    required this.reason,
    required Map<String, Object?> payload,
    this.businessDayId,
    this.approverId,
  }) : payloadJson = _canonicalJson(payload) {
    for (final value in [key, kind, actorId, sessionId, entityType, entityId]) {
      _requiredText(value, 128);
    }
    _requiredText(reason, 1024);
    if (businessDayId != null) _requiredText(businessDayId!, 128);
    if (approverId != null) _requiredText(approverId!, 128);
    if (expectedRevision < 0 || expectedRevision >= 9223372036854775807) {
      throw ArgumentError('Revision cannot be advanced safely.');
    }
  }

  final String key, kind, actorId, sessionId, entityType, entityId, reason;
  final String? businessDayId, approverId;
  final int expectedRevision;
  final String payloadJson;

  String get requestHash => sha256
      .convert(
        utf8.encode(
          _canonicalJson({
            'kind': kind,
            'actor': actorId,
            'entityType': entityType,
            'entityId': entityId,
            'expectedRevision': expectedRevision,
            'reason': reason,
            'businessDay': businessDayId,
            'approver': approverId,
            'payload': jsonDecode(payloadJson),
          }),
        ),
      )
      .toString();
}

/// Snapshots and result are captured before asynchronous work can mutate them.
final class CommandChange {
  CommandChange({
    required Map<String, Object?> result,
    required Map<String, Object?> before,
    required Map<String, Object?> after,
  }) : resultJson = _canonicalJson(result),
       beforeJson = _canonicalJson(before),
       afterJson = _canonicalJson(after);

  final String resultJson, beforeJson, afterJson;
}

final class CommandReceipt {
  const CommandReceipt(this.resultJson, {required this.replayed});
  final String resultJson;
  final bool replayed;
}

final class CommandConflict implements Exception {
  const CommandConflict();
  @override
  String toString() => 'Command ID was already used for different input.';
}

final class StaleCommandRevision implements Exception {
  const StaleCommandRevision();
  @override
  String toString() => 'Record changed. Reload before trying again.';
}

/// All callbacks must await database work and perform no external side effects.
/// Permission/session/day checks belong in [authorize], even for saved retries.
/// Only trusted services may supply callbacks; this is not authentication itself.
final class CommandCoordinator {
  CommandCoordinator({
    required this.database,
    required this.clock,
    required this.ids,
    required this.terminalId,
    required this.appVersion,
  }) {
    _requiredText(terminalId, 128);
    _requiredText(appVersion, 128);
  }

  final PosDatabase database;
  final CommandClock clock;
  final RecordIdSource ids;
  final String terminalId, appVersion;
  static final Object _activeCommand = Object();

  Future<CommandReceipt> execute(
    CommandIntent intent, {
    required Future<void> Function() authorize,
    required Future<CommandChange> Function() apply,
  }) async {
    if (Zone.current[_activeCommand] == true || database.isInsideTransaction) {
      throw StateError('Commands cannot be nested.');
    }
    return runZoned(
      () => database.transaction(() async {
        await authorize();
        final prior = await database
            .customSelect(
              'SELECT request_hash, result_json FROM idempotency_commands WHERE intent_key = ?',
              variables: [Variable(intent.key)],
            )
            .getSingleOrNull();
        final hash = intent.requestHash;
        if (prior != null) {
          if (prior.read<String>('request_hash') != hash) {
            throw const CommandConflict();
          }
          return CommandReceipt(
            prior.read<String>('result_json'),
            replayed: true,
          );
        }
        final version = await database
            .customSelect(
              'SELECT revision FROM command_versions WHERE entity_type = ? AND entity_id = ?',
              variables: [
                Variable(intent.entityType),
                Variable(intent.entityId),
              ],
            )
            .getSingleOrNull();
        if ((version?.read<int>('revision') ?? 0) != intent.expectedRevision) {
          throw const StaleCommandRevision();
        }
        final now = clock.nowUtc();
        if (!now.isUtc) throw StateError('Command clock must return UTC.');
        final timestamp = now.toIso8601String();
        final auditId = ids.nextId();
        _requiredText(auditId, 128);
        final change = await apply();
        await database.customStatement(
          'INSERT INTO idempotency_commands VALUES (?, ?, ?, ?, ?)',
          [intent.key, intent.kind, hash, change.resultJson, timestamp],
        );
        await database.customStatement(
          'INSERT INTO audit_events (id, command_id, entity_type, entity_id, event_type, actor_id, session_id, approver_id, business_day_id, terminal_id, app_version, reason, before_json, after_json, created_at_utc) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
          [
            auditId,
            intent.key,
            intent.entityType,
            intent.entityId,
            intent.kind,
            intent.actorId,
            intent.sessionId,
            intent.approverId,
            intent.businessDayId,
            terminalId,
            appVersion,
            intent.reason,
            change.beforeJson,
            change.afterJson,
            timestamp,
          ],
        );
        if (version == null) {
          await database.customStatement(
            'INSERT INTO command_versions VALUES (?, ?, ?)',
            [intent.entityType, intent.entityId, 1],
          );
        } else {
          final count = await database.customUpdate(
            'UPDATE command_versions SET revision = ? WHERE entity_type = ? AND entity_id = ? AND revision = ?',
            variables: [
              Variable(intent.expectedRevision + 1),
              Variable(intent.entityType),
              Variable(intent.entityId),
              Variable(intent.expectedRevision),
            ],
          );
          if (count != 1) throw const StaleCommandRevision();
        }
        return CommandReceipt(change.resultJson, replayed: false);
      }),
      zoneValues: {_activeCommand: true},
    );
  }
}

void _requiredText(String value, int maximum) {
  if (value.trim().isEmpty ||
      value.length > maximum ||
      value.contains('\u0000')) {
    throw ArgumentError('Invalid command metadata.');
  }
}

String _canonicalJson(Object? value) {
  Object? normalize(Object? item, int depth) {
    if (depth > 32) throw ArgumentError('Command data is too deeply nested.');
    if (item == null || item is String || item is bool || item is int)
      return item;
    if (item is List) return item.map((v) => normalize(v, depth + 1)).toList();
    if (item is Map<String, Object?>) {
      final keys = item.keys.toList()..sort();
      return {for (final key in keys) key: normalize(item[key], depth + 1)};
    }
    throw ArgumentError(
      'Command data must use JSON with integer numbers only.',
    );
  }

  final json = jsonEncode(normalize(value, 0));
  if (utf8.encode(json).length > 65536)
    throw ArgumentError('Command data is too large.');
  return json;
}
