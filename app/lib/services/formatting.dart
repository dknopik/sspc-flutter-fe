import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';
import 'package:intl/intl.dart';
import 'package:rational/rational.dart';

final _eth = Decimal.parse("1000000000000000000");
final _ethCutoff = Decimal.parse("10000000000000000");
final _gwei = Decimal.parse("1000000000");
final _gweiCutoff = Decimal.parse("10000000");
final _format = NumberFormat('#,##0.####');

String formatValue(BigInt value) {
  Decimal val = Decimal.fromBigInt(value);
  if (val.compareTo(_ethCutoff) >= 0) {
    return "${_format.format(DecimalIntl((val / _eth).toDecimal()))} ETH";
  } else if (val.compareTo(_gweiCutoff) >= 0) {
    return "${_format.format(DecimalIntl((val / _gwei).toDecimal()))} gwei";
  } else {
    return "${value.toString()} wei";
  }
}