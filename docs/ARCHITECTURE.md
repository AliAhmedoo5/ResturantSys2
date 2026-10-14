# Architecture decisions

## Platform and boundaries

Use Flutter Windows with Riverpod state, GoRouter navigation and Drift/SQLite persistence, per chapter 15. One machine owns one database; never share a SQLite file across registers. Pure Dart rules live in `packages/pos_domain`; the future app consumes that package through a path dependency.

The application will separate presentation, domain commands and data repositories. A transaction coordinator commits business records, snapshots, ledgers, inventory deltas, audit, idempotency keys and token allocation together. Database constraints enforce uniqueness as well as application checks. PIN authorization must be enforced at command boundaries, not merely by hiding buttons.

## Windows preview foundation

`apps/crunch_cartel` contains the Flutter app. Riverpod owns router lifecycle and a read-only build-capability provider. GoRouter's shell contains shared navigation; `/preview/counter` and `/preview/manager` are explicitly unauthenticated design previews, never trusted role sessions. The setup page is an informational guide, not a wizard that pretends to persist accounts. No financial mutation service is wired into this preview.

The brand is Crunch Cartel, black with bright yellow, per the user's 13 October override. See `DESIGN.md`. The initial Windows runner and dependency lockfile are generated in Actions and imported as reviewed source. The complete release folder, including Flutter DLLs and data, is packaged only after analysis, widget/layout tests, domain regression checks and the Windows build succeed.

Framework references: [Flutter Windows](https://docs.flutter.dev/platform-integration/windows/building), [GoRouter configuration](https://pub.dev/documentation/go_router/latest/topics/Configuration-topic.html), and [Riverpod providers](https://riverpod.dev/docs/concepts2/providers). Context7 tools were unavailable; official documentation was used instead.

## Chapter 32 precedence

Confirmed-order edits are permitted for Cashier while business day and linked trip remain editable. Persisted settlement locks override displayed fulfillment status. Refunds are separate documented financial operations. Canceling a paid sale does not automatically return money. Drafts never allocate tokens; committed canceled tokens are never recycled.

All money is signed 64-bit integer paisa at storage boundaries. Use BigInt intermediates where arithmetic could overflow and check conversion. Initial cash-rounding code only accepts nonnegative cash due and rejects out-of-range results. Later payment coordination applies it once to the final cash balance, persists its signed delta separately and posts ROUNDING_GAIN_LOSS. Refund allocation must use historical rounding rather than this forward-payment helper.

## Execution and reproducibility

All project execution takes place in GitHub Actions on hosted Windows runners. The domain workflow pins Dart 3.13.5, identified and validated on the runner. Before the Flutter shell is accepted, pin its compatible Flutter/Dart SDK and commit dependency lockfiles produced by Actions. The initial domain package has no external dependencies. No deployment/signing/email credentials belong in source control. Publish development artifacts only after all required checks succeed. A domain-only check is not a Windows application build.

Workflow syntax follows the official [Dart setup action](https://github.com/dart-lang/setup-dart) and [checkout action](https://github.com/actions/checkout) documentation.

## Database foundation (chunk 03a)

`packages/pos_data` isolates Drift/SQLite from Flutter and the pure domain package. Schema v1 identifies the database with SQLite application ID `0x43435254` and a singleton format row. The connection uses a background isolate, WAL, synchronous FULL, a five-second busy timeout, foreign keys and a 1000-page automatic checkpoint. Startup checks database integrity and foreign-key consistency. Unexpected database identity, newer schemas, missing metadata and corruption fail without resetting or inventing records.

The opener requires an absolute file in an already provisioned local directory and rejects UNC paths. This is an internal storage foundation, not a complete deployment path policy: platform AppData discovery, ACLs and mapped-drive detection remain required before application integration. Windows writer ownership is covered by chunk 03b1 below. The preview does not yet depend on this package.

Version 1 created only technical metadata; there are no pretend financial or account records. Version 2 adds technical migration history through the backup-gated path described below. Unsupported migrations are rejected. The chapter 32.2 revision tables and nullable approver migration remain explicitly pending, alongside the coordinator and audit schema. No financial posting API is exposed in this chunk.

The `Database foundation` workflow generates Drift code, resolves the committed lockfile, formats, analyzes and runs temporary-file SQLite tests exclusively on hosted Windows. First generation exports a prepared-source artifact; that source and lockfile must be imported and committed before the reproducibility gate can pass. Tests use synthetic SQL fixtures created on the runner, never checked-in database binaries.

API references: [Drift native background connections](https://drift.simonbinder.eu/platforms/vm/) and [migration API](https://drift.simonbinder.eu/migrations/api/). Context7 tools were unavailable; official documentation was consulted.

## Writer ownership (chunk 03b1)

Every `PosDatabase.open` first takes an exclusive Windows byte-range lock in an adjacent `.writer.lock` file, before opening SQLite or creating schema. The handle remains owned until the database isolate closes. A second instance receives `DatabaseAlreadyOpenException`; unrelated filesystem failures retain their original error. Failed initialization closes SQLite and releases the lease. Repeated close calls share one completion future.

Paths are resolved before selecting the marker, so relative segments, Windows case aliases and symbolic directory aliases converge on the same lock. The marker is deliberately never deleted: its existence does not indicate ownership, and retaining it avoids a delete/recreate race. Windows releases the handle lock on process termination. This API explicitly requires Windows because Unix advisory locks have different process semantics.

This prevents cooperating POS instances from creating independent writers. It is not protection against another program directly editing SQLite or deleting/replacing files, and it does not detect hard-link aliases or mapped network drives. Provisioned AppData paths and ACL policy remain required before UI integration. Tests exercise simultaneous opens, repeated close, equivalent paths, stale markers, failed initialization and child-process normal/abrupt exit exclusively on GitHub-hosted Windows.

The coordinator remains a following subchunk. Its durable tables need a schema upgrade; implement the verified backup prerequisite before adding those tables. This change leaves schema v1 intact. Reference: [Dart Windows file-lock semantics](https://api.dart.dev/dart-io/RandomAccessFile/lock.html).

The hosted workflow compiles the separate-process helper with `dart build cli` before running tests. The executable has its own native SQLite assets; launching a nested `dart run` would attempt to replace the test process''s loaded DLL on Windows. Reference: [Dart CLI build](https://dart.dev/tools/dart-build).

## Verified snapshots (chunk 03c1)

`PosDatabase.createSnapshot` uses SQLite `VACUUM INTO` to capture committed state including WAL pages. The live database is not copied or checkpointed as a backup shortcut. The output starts in a unique staging directory under an existing caller-provisioned local backup destination. The copy is converted to standalone DELETE journaling and checked for application identity, schema version, integrity and foreign-key consistency on a worker isolate. Its manifest includes SHA-256, byte size, UTC creation time, app version, schema version, validation state and an explicit `encrypted: false`. Business-day metadata is null until the business-day model exists.

Database and flushed manifest are published together by same-parent directory rename. Failures clean only the current staging directory; a missing destination is not recreated or treated as success. A process crash can leave a `.pending-` folder, which is not a published archive. Callers must await completion before closing storage and cannot call the snapshot operation inside a transaction.

`PosDatabase.verifySnapshot` checks the manifest, content hash/size, database identity, schema, full integrity and foreign keys independently in a worker isolate without modifying database contents. Checksums detect accidental corruption, not malicious replacement of both content and manifest. The archive remains unencrypted; ACL provisioning, encryption/key recovery, retention, migration gating, restore authorization and hardware power-loss testing remain future work. No customer data or database archive is committed or uploaded by CI; tests create synthetic fixtures on the hosted runner.

Reference: [SQLite VACUUM INTO consistency and durability](https://www.sqlite.org/lang_vacuum.html). Version 1 business tables are unchanged. Do not equate this backup seam with verified forward migrations or production disaster recovery.

## Backup-gated v1 → v2 upgrade (chunk 03c2a)

`PosDatabase.open(file, migrationBackup: MigrationBackup(...))` accepts an existing, caller-provisioned local backup destination and application version. Fresh databases are created at v2; an existing v2 database needs no upgrade backup. A v1 database cannot open for use without the backup policy. Missing storage, invalid metadata and failed snapshot verification abort the upgrade without replacing the source or fabricating an archive.

The existing Windows writer lease stays held across source validation, snapshot creation, independent snapshot verification, the Drift migration transaction and final opening. Source identity, integrity and foreign keys are checked before schema mutations. Snapshot metadata uses SQLite's actual `user_version`, rather than Drift's target version, so the recovery archive remains labelled v1. The only supported transition is 1 → 2.

The upgrade adds `schema_upgrades` and records source/target versions, UTC timestamp, application version, archive directory and SHA-256. Table creation, history insertion, integrity verification and SQLite version advancement commit in one transaction. Drift's subsequent version write repeats the same value. A failed migration closes the database, releases the writer lease and exposes the retained archive location via `DatabaseMigrationException`; it does not automatically copy files back or destroy the original database. Existing rows are neither rewritten nor reseeded.

Frozen synthetic v1 SQL fixtures are created only on Actions. Tests cover preserved signed amounts/text, source-version archives, identical fresh/upgraded history columns, missing backup configuration/destination, invalid metadata, schema conflicts, retry and missing v2 history. This subchunk does not claim hardware power-loss recovery, a restore wizard, AppData/ACL integration, or chapter 32.2 financial table migration acceptance. Those require later chunks and real schema prerequisites.

References: [Drift migration transaction boundaries](https://drift.simonbinder.eu/migrations/api/), [SQLite transactional commit and rollback](https://www.sqlite.org/lang_transaction.html).
