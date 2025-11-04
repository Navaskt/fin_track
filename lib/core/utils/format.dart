import 'package:intl/intl.dart';

final _currency = NumberFormat.currency(symbol: 'AED ', decimalDigits: 2);
final _date = DateFormat('yyyy-MM-dd');

String fmtMoney(num v) => _currency.format(v);
String fmtDate(DateTime d) => _date.format(d);
String friendlyDate(DateTime d) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final date = DateTime(d.year, d.month, d.day);
  if (date == today) return 'Today';
  if (date == today.subtract(const Duration(days: 1))) return 'Yesterday';
  return DateFormat('dd MMM yyyy').format(d);
}

String formatAED(num v) {
  final f = NumberFormat.currency(name: 'AED', symbol: 'AED ');
  return f.format(v);
}
