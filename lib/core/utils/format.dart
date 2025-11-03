import 'package:intl/intl.dart';

final _currency = NumberFormat.currency(symbol: 'AED ', decimalDigits: 2);
final _date = DateFormat('yyyy-MM-dd');

String fmtMoney(num v) => _currency.format(v);
String fmtDate(DateTime d) => _date.format(d);
