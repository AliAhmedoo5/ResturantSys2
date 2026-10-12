# Restaurant POS & ERP

Offline Windows restaurant application based on `Restaurant_POS_COMPLETE_Master_v6.md`.

## Current status

Chunk 01 is prepared locally: delivery plan, contributor rules, initial pure Dart cash-rounding policy and its regression tests, plus GitHub Actions validation. It is **not CI-verified** and is not yet a usable POS application. A GitHub repository must be supplied before remote validation can run.

The domain package in `packages/pos_domain` will be consumed by the Flutter Windows application. The UI, database, authentication and transactional services are subsequent chunks.

## Development policy

Only file editing/inspection and repository operations happen locally. All project execution, dependency resolution, formatting, tests, generators and builds run on GitHub-hosted Actions runners. Do not install Flutter/Dart or run this project locally for development.

The `Domain foundation` workflow runs on pushes, pull requests and manual dispatch. It checks formatting, analyzes the domain package and runs regression tests on Windows. A failed check blocks acceptance of this chunk. Future chunks add Flutter Windows builds and downloadable application artifacts.

See [implementation plan](docs/IMPLEMENTATION_PLAN.md) and [architecture decisions](docs/ARCHITECTURE.md). Chapter 32 of the original specification takes precedence over older wording.
