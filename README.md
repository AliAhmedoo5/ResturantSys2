# Restaurant POS & ERP

Offline Windows restaurant application based on `Restaurant_POS_COMPLETE_Master_v6.md`.

## Current status

Chunk 01 is implemented and CI-verified: delivery plan, contributor rules, initial pure Dart cash-rounding policy and its regression tests, plus GitHub Actions validation. [Windows checks passed](https://github.com/AliAhmedoo5/ResturantSys2/actions/runs/38296356193) for commit `6780c0d`. This is not yet a usable POS application.

Chunk 02 provides the CI-verified Crunch Cartel black/yellow design preview. The current access integration adds real setup and sign-in; billing remains disabled. See [early-access instructions and limitations](docs/PREVIEW.md) and the implementation plan for exact verification evidence.

Chunk 03 includes the `packages/pos_data` Drift/SQLite foundation, Windows writer ownership, verified backups and backup-gated upgrades to schema v4. The command coordinator atomically saves changes, retry results, audit and version advancement. The earlier 86 database/authentication tests passed in [hosted Windows CI](https://github.com/AliAhmedoo5/ResturantSys2/actions/runs/38810830217), including concurrent retries, damaged migration rollback and process exits before/after commit. Application startup now connects private storage through an access repository. Restore orchestration and financial schema integration remain pending; consult the implementation plan for exact evidence and remaining gates.

Chunk 04 includes the verified two-role policy, [23 tested security primitives](https://github.com/AliAhmedoo5/ResturantSys2/actions/runs/38810830248) and database-backed authentication services. The access integration adds recovery-kit acknowledgement, mandatory first Manager/distinct primary Cashier creation, sign-in, focus/idle locking and role-specific readiness pages. No session is granted by account setup. Missing or corrupt installation storage is never silently replaced. Audited Manager credential administration, reauthentication, authorized recovery/restore UI, configurable policy and drawer binding remain pending. The project is not ready for live restaurant use.

## Development policy

Only file editing/inspection and repository operations happen locally. All project execution, dependency resolution, formatting, tests, generators and builds run on GitHub-hosted Actions runners. Do not install Flutter/Dart or run this project locally for development.

The `Domain foundation`, `Database foundation` and `Crunch Cartel Windows` workflows run on GitHub-hosted Windows. They validate domain rules, generate and verify Drift source, test file-backed persistence, and build the complete Windows preview. A failed required check blocks acceptance; generated source and lockfiles must match their committed versions.

See [implementation plan](docs/IMPLEMENTATION_PLAN.md) and [architecture decisions](docs/ARCHITECTURE.md). Chapter 32 of the original specification takes precedence over older wording.
