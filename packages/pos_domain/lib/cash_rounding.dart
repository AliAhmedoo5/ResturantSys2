/// Final physical cash balance, per specification 32.3.
///
/// Call once after exact digital allocations. Do not use for refunds, item
/// pricing, or COD confirmation before the collection method is known.
class CashRounding {
  const CashRounding._(this.exactPaisa, this.payablePaisa);

  final int exactPaisa;
  final int payablePaisa;

  int get adjustmentPaisa => payablePaisa - exactPaisa;

  factory CashRounding.forFinalBalance(int exactPaisa) {
    if (exactPaisa < 0) {
      throw ArgumentError.value(
          exactPaisa, 'exactPaisa', 'Must be nonnegative');
    }
    final maxPaisa = BigInt.parse('9223372036854775807');
    final exact = BigInt.from(exactPaisa);
    final hundred = BigInt.from(100);
    final rounded = ((exact + BigInt.from(50)) ~/ hundred) * hundred;
    if (exact > maxPaisa || rounded > maxPaisa) {
      throw RangeError('Cash balance exceeds signed 64-bit integer paisa');
    }
    return CashRounding._(exactPaisa, rounded.toInt());
  }
}
