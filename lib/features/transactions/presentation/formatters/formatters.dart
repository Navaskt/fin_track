import 'package:fin_track/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Reuse single formatters (faster, consistent)
final NumberFormat _currency = NumberFormat.currency(
  name: 'AED',
  symbol: 'AED ',
  decimalDigits: 2,
);

final DateFormat _date = DateFormat('yyyy-MM-dd');

// Optional: localized long date used in friendlyDate fallback
final DateFormat _longDate = DateFormat('dd MMM yyyy');

// Public API (kept as-is)
String fmtMoney(num v) => _currency.format(v);
String fmtDate(DateTime d) => _date.format(d);

String friendlyDate(DateTime d, BuildContext context) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final date = DateTime(d.year, d.month, d.day);
  if (date == today) return context.loc.todayLabel;
  if (date == today.subtract(const Duration(days: 1))) return context.loc.yesterdayLabel;
  return _longDate.format(d);
}

// Kept for backward compatibility; reuses the shared currency formatter above
String formatAED(num v) => _currency.format(v);

// ---------------------------------------------------------------------------
// Compact money formatter
// Examples:
//   fmtMoneyCompact(12450)           -> "AED 12.5K"
//   fmtMoneyCompact(10000, decimals: 0) -> "AED 10K"
//   fmtMoneyCompact(950)             -> "AED 950.00" (not compact under threshold)
//   fmtMoneyCompact(-1523000)        -> "AED -1.52M"
//   fmtMoneyCompact(12000, withSymbol: false) -> "12K"
// ---------------------------------------------------------------------------
String fmtMoneyCompact(
  num v, {
  int decimals = 1,
  bool withSymbol = true,
  bool trimTrailingZeros = true,
  num threshold = 1000, // values below this use full format
}) {
  // For small values, keep the regular currency format
  if (v.abs() < threshold) {
    return fmtMoney(v);
  }

  // Build a compact currency formatter on demand (decimals and symbol may vary)
  final f = NumberFormat.compactCurrency(
    name: 'AED',
    symbol: withSymbol ? 'AED ' : '',
    decimalDigits: decimals,
  );

  var s = f.format(v);

  // Optionally strip trailing ".0" before K/M/B/T to keep it clean (e.g., "12.0K" -> "12K")
  if (trimTrailingZeros && decimals > 0) {
    for (final suf in const ['K', 'M', 'B', 'T']) {
      s = s.replaceAll('.0$suf', suf);
    }
  }

  return s;
}
