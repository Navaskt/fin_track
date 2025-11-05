import 'package:fin_track/features/transactions/presentation/controllers/transaction_providers.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../transactions/domain/entities/transaction_entity.dart';
import '../../data/model/insights_model.dart';

// Selected month (default: current month)
final selectedMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month); // normalize
});

extension _TxExt on DateTime {
  DateTime get ymd => DateTime(year, month, day);
}

bool _isSameMonth(DateTime a, DateTime b) => a.year == b.year && a.month == b.month;

// Aggregator
final insightsProvider = Provider<InsightsData>((ref) {
  final selectedMonth = ref.watch(selectedMonthProvider);
  final txs = ref.watch(transactionsStreamProvider).maybeWhen(
    data: (v) => v, orElse: () => <TransactionEntity>[],
  );

  // Filter to selected month
  final monthTxs = txs.where((t) => _isSameMonth(t.date, selectedMonth)).toList();

  double income = 0, expense = 0;
  final byCategoryMap = <String, double>{};
  final byDayMap = <DateTime, double>{};

  for (final t in monthTxs) {
    final isExpense = t.amount < 0;
    final val = t.amount.abs();

    if (isExpense) {
      expense += val;
      byCategoryMap.update(t.category, (p) => p + val, ifAbsent: () => val);
      final day = t.date.ymd;
      byDayMap.update(day, (p) => p + val, ifAbsent: () => val);
    } else {
      income += val;
      // optional: also plot income trend if you want
    }
  }

  final totalExpense = expense == 0 ? 1 : expense; // avoid /0
  final slices = byCategoryMap.entries
      .map((e) => CategorySlice(
            category: e.key,
            amount: e.value,
            ratio: e.value / totalExpense,
          ))
      .toList()
    ..sort((a,b) => b.amount.compareTo(a.amount));

  // Fill missing days with 0 for a smooth line
  final start = DateTime(selectedMonth.year, selectedMonth.month, 1);
  final end = DateTime(selectedMonth.year, selectedMonth.month + 1, 0);
  final daily = <MapEntry<DateTime,double>>[];
  for (int i = 0; i < end.day; i++) {
    final day = DateTime(start.year, start.month, i+1);
    daily.add(MapEntry(day, byDayMap[day] ?? 0));
  }

  final summary = MonthlySummary(month: selectedMonth, income: income, expense: expense);
  return InsightsData(summary: summary, byCategory: slices, dailyExpense: daily);
});
