import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/transaction_entity.dart';
import 'budget_provider.dart';
import 'transaction_providers.dart';

class BudgetStatus {
  const BudgetStatus({
    required this.spent,
    required this.budget,
    required this.monthKey,
  });
  final double spent;
  final double? budget;
  final DateTime monthKey;

  double? get ratio => (budget == null || budget == 0) ? null : spent / budget!;
}

final currentMonthExpenseProvider = Provider<double>((ref) {
  final now = DateTime.now();
  final txs = ref
      .watch(transactionsStreamProvider)
      .maybeWhen(data: (v) => v, orElse: () => <TransactionEntity>[]);
  return txs
      .where(
        (t) =>
            t.date.year == now.year &&
            t.date.month == now.month &&
            t.amount < 0,
      )
      .fold<double>(0, (sum, t) => sum + t.amount.abs());
});

final budgetStatusProvider = Provider<BudgetStatus>((ref) {
  final now = DateTime.now();
  final monthKey = DateTime(now.year, now.month);
  final spent = ref.watch(currentMonthExpenseProvider);
  final budget = ref
      .watch(budgetForMonthProvider(monthKey))
      .maybeWhen(data: (v) => v, orElse: () => null);
  return BudgetStatus(spent: spent, budget: budget, monthKey: monthKey);
});
