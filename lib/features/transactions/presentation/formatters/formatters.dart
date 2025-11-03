// presentation/formatters.dart
import 'package:intl/intl.dart';

String formatMonthYear(DateTime monthKey) {
  // Example: Nov 2025
  return DateFormat('MMM yyyy').format(monthKey);
}

String formatAED(num value) {
  // Shows: AED 1,234.50
  final f = NumberFormat.currency(name: 'AED', symbol: 'AED ');
  return f.format(value);
}
