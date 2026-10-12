# Project instructions

- Read Restaurant_POS_COMPLETE_Master_v6.md for the feature being changed. Chapter 32 overrides older conflicting requirements; chapters 30 and 31 supply the other final policies.
- Run all dependency installation, generators, formatters, analysis, tests, application execution, builds, packaging and migrations exclusively on GitHub-hosted Actions runners. Never run them on the user's machine or a self-hosted runner. Local file inspection/editing and Git transport are permitted.
- Deliver small, reviewable chunks using docs/IMPLEMENTATION_PLAN.md. Record CI evidence before marking a chunk verified. Never equate written tests with passing tests.
- Target Flutter Windows, Riverpod, GoRouter, Drift/SQLite. Keep pure Dart business rules independent of UI and storage. Widgets must not issue SQL or calculate authoritative financial totals.
- Exactly two roles: Cashier and Manager. Manager must never perform cashier operations.
- Use integer paisa with checked arithmetic; no floating-point financial calculations. Cash rounding applies only to the final cash balance.
- Transactional commands must coordinate audit, ledgers, inventory, version checks and idempotency. Never simulate persistence with in-memory data in a production workflow.
- Zero/negative stock never blocks checkout, but missing/invalid recipes do. Manual payment recording only; no payment gateway integrations.
- Do not commit credentials, real customer data, production databases or private report exports.
