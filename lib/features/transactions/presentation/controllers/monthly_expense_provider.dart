// Expense-only sum for a given month (absolute of negatives)
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'transaction_providers.dart';

final monthExpenseOnlyProvider = Provider.family<AsyncValue<double>, DateTime>(
  (ref, monthKey) {
    final txs = ref.watch(transactionsStreamProvider);
    return txs.whenData((list) {
      final key = DateTime(monthKey.year, monthKey.month, 1);
      double sum = 0;
      for (final t in list) {
        final k = DateTime(t.date.year, t.date.month, 1);
        if (k == key && t.amount < 0) {
          sum += (-t.amount); // abs of negative
        }
      }
      return sum;
    });
  },
);