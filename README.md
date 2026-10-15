# Restaurant POS & ERP

Offline Windows restaurant application based on `Restaurant_POS_COMPLETE_Master_v6.md`.

## Current status

Chunk 01 is implemented and CI-verified: delivery plan, contributor rules, initial pure Dart cash-rounding policy and its regression tests, plus GitHub Actions validation. [Windows checks passed](https://github.com/AliAhmedoo5/ResturantSys2/actions/runs/38296356193) for commit `6780c0d`. This is not yet a usable POS application.

Chunk 02 provides a CI-verified Crunch Cartel Windows design preview with black/yellow styling. See [preview download and limitations](docs/PREVIEW.md). Authentication and billing are not enabled.

Chunk 03 includes the isolated `packages/pos_data` Drift/SQLite foundation, Windows writer ownership, verified backups and backup-gated upgrades to schema v3. The command coordinator atomically saves changes, retry results, audit and version advancement. All 58 database tests passed in [hosted Windows CI](https://github.com/AliAhmedoo5/ResturantSys2/actions/runs/38620443141), including concurrent retries and process exits before/after commit. It is not yet connected to the preview. Authentication integration, restore orchestration and platform storage integration remain pending; consult the implementation plan for exact evidence and remaining gates.

Chunk 04 foundations include the verified two-role capability policy and the isolated `pos_security` package. Its [nine hosted security tests](https://github.com/AliAhmedoo5/ResturantSys2/actions/runs/38622596760) cover Argon2id PIN verification, keyed fingerprints, native Windows DPAPI and encrypted recovery envelopes. These are internal components, not a completed login: protected key persistence, persisted lockout, credentials/sessions and first-run onboarding remain pending.

## Development policy

Only file editing/inspection and repository operations happen locally. All project execution, dependency resolution, formatting, tests, generators and builds run on GitHub-hosted Actions runners. Do not install Flutter/Dart or run this project locally for development.

The `Domain foundation`, `Database foundation` and `Crunch Cartel Windows` workflows run on GitHub-hosted Windows. They validate domain rules, generate and verify Drift source, test file-backed persistence, and build the complete Windows preview. A failed required check blocks acceptance; generated source and lockfiles must match their committed versions.

See [implementation plan](docs/IMPLEMENTATION_PLAN.md) and [architecture decisions](docs/ARCHITECTURE.md). Chapter 32 of the original specification takes precedence over older wording.
