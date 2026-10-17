# Crunch Cartel — Windows early access 0.3

This unsigned development build connects protected local storage, first-run Manager/Cashier account creation, PIN sign-in and locking. It does not take payments or open a business day or shift. The older design-preview routes remain read-only and do not authorize operations. This is not ready for live restaurant use.

Download the `Crunch-Cartel-Windows-preview` artifact from a successful **Crunch Cartel Windows** Actions run. Extract the entire ZIP into one folder. Keep the EXE, DLLs and `data` directory together; the EXE alone is insufficient. The executable is `crunch_cartel.exe`. This is a portable preview, not a signed installer.

Development execution, tests, screenshots and builds run exclusively on GitHub-hosted runners. Do not run local build commands. A manual launch on restaurant hardware is a later user acceptance activity, subject to the user's execution preference.

Startup opens setup or sign-in. Tab/Shift+Tab moves focus; Enter submits the final PIN field. Switching profiles locks the existing session and requires another PIN. Losing application focus hides recovery information, clears PIN fields and locks a signed-in session. Idle sessions expire after five minutes; background checks do not extend this period.

The installation is named Crunch Cartel, with PKR and an initial inclusive 0% tax policy displayed. Data is stored under the current Windows user's LocalAppData/CrunchCartel protected directory. Local migration snapshots are kept in its backups child; they do not protect against drive loss. Configurable restaurant settings, external encrypted backup/restore and replacement-hardware recovery remain pending.

Before creating accounts, save **both** the recovery code and encrypted key envelope offline and separately from this computer. The code is not saved by the application. If setup was interrupted after key publication, the original kit cannot be displayed again: continue only if you still have it. Do not delete installation files to restart setup. Missing or corrupt established storage fails closed; keep the data and contact support. The kit recovers installation key material; it is not a staff PIN reset or a completed restore workflow.

Create a Manager with a confirmed 4–8 digit PIN and a distinct primary Cashier with a confirmed four-digit PIN. Account creation does not sign anyone in. After sign-in, role-specific readiness pages explain the still-pending menu/recipes, Manager day opening and Cashier shift/opening-float steps. No fake saleable menu or enabled checkout is provided.

## Earlier verified design preview

Commit `185de7500a1dcde083a040985557270dfb25b99a` passed [Windows Actions](https://github.com/AliAhmedoo5/ResturantSys2/actions/runs/38298514648), including analysis, four widget tests, domain regressions, release compilation and native startup. Download [Crunch-Cartel-Windows-preview-3](https://github.com/AliAhmedoo5/ResturantSys2/actions/runs/38298514648/artifacts/11770316522) while the artifact remains available (30-day retention). Screenshots from the same run cover welcome, counter, management and setup at 100%, 125% and 150% DPI. These checks verify the preview only; production and restaurant-hardware acceptance remain pending.
