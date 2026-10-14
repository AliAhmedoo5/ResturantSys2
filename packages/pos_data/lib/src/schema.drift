CREATE TABLE database_metadata (
  singleton INTEGER NOT NULL PRIMARY KEY CHECK (singleton = 1),
  format_tag TEXT NOT NULL CHECK (format_tag = 'crunch-cartel')
);

CREATE TABLE schema_upgrades (
  to_version INTEGER NOT NULL PRIMARY KEY CHECK (to_version >= 2),
  from_version INTEGER NOT NULL CHECK (from_version >= 1 AND from_version < to_version),
  applied_at_utc TEXT NOT NULL,
  app_version TEXT NOT NULL,
  backup_directory TEXT NOT NULL,
  backup_sha256 TEXT NOT NULL CHECK (length(backup_sha256) = 64)
);

CREATE TABLE idempotency_commands (
  intent_key TEXT NOT NULL PRIMARY KEY CHECK (length(intent_key) BETWEEN 1 AND 128),
  kind TEXT NOT NULL,
  request_hash TEXT NOT NULL CHECK (length(request_hash) = 64),
  result_json TEXT NOT NULL,
  created_at_utc TEXT NOT NULL
);

CREATE TABLE command_versions (
  entity_type TEXT NOT NULL,
  entity_id TEXT NOT NULL,
  revision INTEGER NOT NULL CHECK (revision >= 1),
  PRIMARY KEY (entity_type, entity_id)
);

CREATE TABLE audit_events (
  id TEXT NOT NULL PRIMARY KEY,
  command_id TEXT NOT NULL UNIQUE REFERENCES idempotency_commands(intent_key),
  entity_type TEXT NOT NULL,
  entity_id TEXT NOT NULL,
  event_type TEXT NOT NULL,
  actor_id TEXT NOT NULL,
  session_id TEXT NOT NULL,
  approver_id TEXT,
  business_day_id TEXT,
  terminal_id TEXT NOT NULL,
  app_version TEXT NOT NULL,
  reason TEXT NOT NULL,
  before_json TEXT NOT NULL,
  after_json TEXT NOT NULL,
  created_at_utc TEXT NOT NULL
);

CREATE TRIGGER audit_events_no_update BEFORE UPDATE ON audit_events
BEGIN SELECT RAISE(ABORT, 'Audit events are immutable'); END;
CREATE TRIGGER audit_events_no_delete BEFORE DELETE ON audit_events
BEGIN SELECT RAISE(ABORT, 'Audit events are immutable'); END;
CREATE TRIGGER commands_no_update BEFORE UPDATE ON idempotency_commands
BEGIN SELECT RAISE(ABORT, 'Command results are immutable'); END;
CREATE TRIGGER commands_no_delete BEFORE DELETE ON idempotency_commands
BEGIN SELECT RAISE(ABORT, 'Command results are immutable'); END;
CREATE TRIGGER commands_no_replace BEFORE INSERT ON idempotency_commands
WHEN EXISTS (SELECT 1 FROM idempotency_commands WHERE intent_key = NEW.intent_key)
BEGIN SELECT RAISE(ABORT, 'Command results cannot be replaced'); END;
CREATE TRIGGER audit_events_no_replace BEFORE INSERT ON audit_events
WHEN EXISTS (SELECT 1 FROM audit_events WHERE id = NEW.id OR command_id = NEW.command_id)
BEGIN SELECT RAISE(ABORT, 'Audit events cannot be replaced'); END;
