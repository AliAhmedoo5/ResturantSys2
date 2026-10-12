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
