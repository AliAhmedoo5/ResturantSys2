# Small-chunk delivery plan

Each numbered chunk is a separate reviewable change. Feature chunks include persistence, domain commands, UI, audit and relevant tests. If a chunk becomes too large, split it before implementation. Every chunk must pass GitHub Actions before being called verified; releases additionally require owner acceptance on restaurant hardware.

| Chunk | Deliverable | Acceptance gate | Specification |
|---|---|---|---|
| 01 | Project rules, roadmap, domain package and Actions; cash rounding regression cases | Windows domain analysis and tests pass remotely | 15, 20, 32.3 |
| 02 | Flutter Windows shell, theme, routing, pinned SDK/dependencies and build artifacts | Windows build and widget smoke tests; downloadable preview | 14, 15 |
| 03 | Drift database, initial migrations, transaction coordinator, clock/IDs, audit and backup seams | Fresh database and upgrade fixtures pass; rollback and idempotency verified | 16–18, 32.2 |
| 04 | First-run Manager and mandatory Cashier creation, secure PIN storage and lockout | Cannot finish without distinct accounts; role denial and recovery tests | 03, 18, 32.6 |
| 05 | Business days and cashier shifts | Manager opens day; cashier opens shift; role separation enforced | 02, 11, 28 |
| 06 | Inventory items, units, menu categories/items and mandatory recipes | Invalid recipe cannot publish; stock availability does not affect publication | 04, 08, 31 |
| 07 | Modifier groups, variants and recipe expansion | No Mayo/Extra Mayo exclusive; deterministic BOM snapshots | 04, 31, 32.7 |
| 08 | Deals, discount presets and exact price/tax allocation | All deal paths have recipes; default inclusive 0%; deterministic residues | 04–05, 17, 32.3–4 |
| 09 | Customer phone/address lookup, cart, hold and recall | Restart preserves drafts; drafts never consume tokens | 06, 27, 32.5 |
| 10 | Atomic order confirmation and manual cash/digital/split/COD tender | Retry produces one order/token/stock posting; cash rounding reconciles | 06–07, 28, 30–32 |
| 11 | Preparation, takeaway/dine-in/delivery lifecycle | Fulfillment and payment remain independent; COD may stay unpaid | 02, 07, 28 |
| 12 | Rider assignments, trips and cash settlement | Collected, rider-held and handed-over cash reconcile | 07, 28, 32.1 |
| 13 | Confirmed-order revisions, cancellation and separate refunds | Settlement/day locks; revision concurrency; explicit refund evidence and stock disposition | 30, 32.1–2 |
| 14 | Stock receipts, wastage and physical counts | Negative balances reconcile on receipt without double deduction | 08, 28, 30 |
| 15 | Suppliers, permitted products, purchases and Khata | Stock, liability and payments reconcile atomically without duplicates | 09, 28 |
| 16 | Drawer movements, expenses, blind shift close and cash handover | Nullable approver; expected cash and counted variance reconcile | 10–11, 32.2 |
| 17 | Staff pay terms, salary accruals, advances and payments | Effective dates, wages and expenses do not double-count | 03, 12, 28 |
| 18 | Owner reports and PDF/XLSX/CSV exports | Totals drill down to source postings; profit quality explicit | 13, 21, 29 |
| 19 | Day close, local reports and durable email outbox | Close commits offline; retries cannot duplicate close or ledger postings | 25, 28 |
| 20 | Backup/restore, privacy, failure recovery and installer | Restore and upgrade drills, crash/disk-full tests, Windows release artifact | 18–20, 29 |
| 21 | Full operational acceptance and rollout | Complete manager/cashier day, security/performance checks and owner signoff | 19, 29, 32.8 |

## Progress

- Chunk 01: implemented; formatting, analysis and cash-rounding regression suite passed on GitHub-hosted Windows, commit `6780c0d`, [Actions evidence](https://github.com/AliAhmedoo5/ResturantSys2/actions/runs/38296356193). Includes all 100 fractional-rupee residues, split cash balance examples, negative-input rejection and the maximum signed integer boundary.
- Chunk 02: verified for preview scope at commit `185de7500a1dcde083a040985557270dfb25b99a`. [Windows Actions evidence](https://github.com/AliAhmedoo5/ResturantSys2/actions/runs/38298514648): committed formatting unchanged, Flutter analysis clean, all four widget tests passed (preview navigation, disabled checkout, keyboard help and four routes at 100%/125%/150% DPI), bundled-SDK domain regressions passed, release build passed and native startup smoke check passed. [Standalone domain evidence](https://github.com/AliAhmedoo5/ResturantSys2/actions/runs/38298514545) also passed. Available artifacts checked 13 October 2026: `Crunch-Cartel-Windows-preview-3`, `crunch-cartel-ui-screenshots` and `crunch-cartel-prepared-source`. The 150% counter screenshot was visually inspected: cart and disabled checkout remain visible. This is an unsigned design preview; real authentication, persistence and billing remain unimplemented, and restaurant-hardware acceptance is outstanding.
- Chunk 03a: implemented, awaiting hosted CI. File-backed Drift schema v1, background connection, WAL/FULL synchronous/foreign-key settings, database identity and version guards, file persistence and failure tests. Not connected to preview UI or financial commands.
- Chunk 03b: pending. Transaction coordinator, durable idempotency/audit, version checks, clock/ID seams and writer ownership. Review posted-event invariants before monetary posting.
- Chunk 03c: pending. Backup-gated forward migrations, historical upgrade fixtures (including chapter 32.2), recovery and platform storage integration. Chunk 03 as a whole is not verified.
- Chunks 04–21: not implemented.
- No local dependency installation, test, formatter, app execution or build has been performed.

## Completion evidence per chunk

Record changed requirements, Actions run URL/commit, relevant passing checks, available artifacts, and remaining limitations. Do not start persistent monetary posting before reviewing the posted-event schema and invariants. Keep release criteria separate from preview build success.

## Configuration needed before live use

Manager/accountant must configure actual tax treatment, salary policies, supplier units, backup destinations/recovery, recipient consent and email settings. Default tax is inclusive 0%; it is not a legal determination. Automatic WhatsApp requires a separately chosen official provider; it does not block the initial email implementation. Kitchen printing, payment APIs, cloud sync and rider tracking are excluded.
