import 'package:pos_domain/cash_rounding.dart';

// Dependency-free executable regression suite. Explicit failures remain active
// even when Dart assertions are disabled. Run only in GitHub Actions.
void main() {
  final cases = <(int, int, int)>[
    (0, 0, 0),
    (49, 0, -49),
    (50, 100, 50),
    (100, 100, 0),
    (61625, 61600, -25),
    (61649, 61600, -49),
    (61650, 61700, 50),
    (41625, 41600, -25), // Exact wallet 20000, final cash remainder.
    (41600, 41600, 0), // Exact wallet 20025, final cash remainder.
    (9223372036854775700, 9223372036854775700, 0),
    (9223372036854775807, 9223372036854775800, -7),
  ];
  for (final (exact, payable, adjustment) in cases) {
    final result = CashRounding.forFinalBalance(exact);
    if (result.exactPaisa != exact ||
        result.payablePaisa != payable ||
        result.adjustmentPaisa != adjustment) {
      throw StateError('Incorrect cash rounding for $exact');
    }
  }

  var rejectedNegative = false;
  try {
    CashRounding.forFinalBalance(-1);
  } on ArgumentError {
    rejectedNegative = true;
  }
  if (!rejectedNegative) throw StateError('Negative balance accepted');

  // Every possible fractional rupee obeys the specified half-up boundary.
  for (var residue = 0; residue < 100; residue++) {
    final result = CashRounding.forFinalBalance(10000 + residue);
    final expected = residue < 50 ? 10000 : 10100;
    if (result.payablePaisa != expected ||
        result.exactPaisa + result.adjustmentPaisa != result.payablePaisa) {
      throw StateError('Rounding invariant failed at residue $residue');
    }
  }
  print('Passed cash rounding examples, boundaries and 100 residue cases.');
}
