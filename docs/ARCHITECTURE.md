# Architecture decisions

## Platform and boundaries

Use Flutter Windows with Riverpod state, GoRouter navigation and Drift/SQLite persistence, per chapter 15. One machine owns one database; never share a SQLite file across registers. Pure Dart rules live in `packages/pos_domain`; the future app consumes that package through a path dependency.

The application will separate presentation, domain commands and data repositories. A transaction coordinator commits business records, snapshots, ledgers, inventory deltas, audit, idempotency keys and token allocation together. Database constraints enforce uniqueness as well as application checks. PIN authorization must be enforced at command boundaries, not merely by hiding buttons.

## Chapter 32 precedence

Confirmed-order edits are permitted for Cashier while business day and linked trip remain editable. Persisted settlement locks override displayed fulfillment status. Refunds are separate documented financial operations. Canceling a paid sale does not automatically return money. Drafts never allocate tokens; committed canceled tokens are never recycled.

All money is signed 64-bit integer paisa at storage boundaries. Use BigInt intermediates where arithmetic could overflow and check conversion. Initial cash-rounding code only accepts nonnegative cash due and rejects out-of-range results. Later payment coordination applies it once to the final cash balance, persists its signed delta separately and posts ROUNDING_GAIN_LOSS. Refund allocation must use historical rounding rather than this forward-payment helper.

## Execution and reproducibility

All project execution takes place in GitHub Actions on hosted Windows runners. The first domain workflow uses Dart stable as an initial bootstrap; before the Flutter shell is accepted, pin the exact Flutter/Dart SDK and commit dependency lockfiles produced by Actions. No deployment/signing/email credentials belong in source control. Publish development artifacts only after all required checks succeed. A domain-only check is not a Windows application build.

Workflow syntax follows the official [Dart setup action](https://github.com/dart-lang/setup-dart) and [checkout action](https://github.com/actions/checkout) documentation.
