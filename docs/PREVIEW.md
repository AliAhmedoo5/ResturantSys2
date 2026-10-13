# Crunch Cartel — Windows preview 0.2

This unsigned development preview introduces the black/yellow brand, navigation, counter layout, management layout and setup guide. It does not create accounts, save restaurant records, take payments, or open a real business day. PIN authentication and the database are not implemented yet. Preview navigation is not a login or authorization mechanism.

Download the `Crunch-Cartel-Windows-preview` artifact from a successful **Crunch Cartel Windows** Actions run. Extract the entire ZIP into one folder. Keep the EXE, DLLs and `data` directory together; the EXE alone is insufficient. The executable is `crunch_cartel.exe`. This is a portable preview, not a signed installer.

Development execution, tests, screenshots and builds run exclusively on GitHub-hosted runners. Do not run local build commands. A manual launch on restaurant hardware is a later user acceptance activity, subject to the user's execution preference.

Navigation: use the welcome screen to preview Counter or Management; return using Welcome or Ctrl+Home. F1 opens keyboard help. Tab/Shift+Tab moves focus; Enter/Space activates controls; Escape closes dialogs.

The setup guide describes the later required sequence: restaurant settings, Manager PIN, distinct primary Cashier with four-digit PIN, recipes/menu, Manager day opening, Cashier login and shift opening. It is not an executable wizard in this chunk.

## Verified preview build

Commit `185de7500a1dcde083a040985557270dfb25b99a` passed [Windows Actions](https://github.com/AliAhmedoo5/ResturantSys2/actions/runs/38298514648), including analysis, four widget tests, domain regressions, release compilation and native startup. Download [Crunch-Cartel-Windows-preview-3](https://github.com/AliAhmedoo5/ResturantSys2/actions/runs/38298514648/artifacts/11770316522) while the artifact remains available (30-day retention). Screenshots from the same run cover welcome, counter, management and setup at 100%, 125% and 150% DPI. These checks verify the preview only; production and restaurant-hardware acceptance remain pending.
