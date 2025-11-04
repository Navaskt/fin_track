import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';

import '../../data/repositories/budget_repository_impl.dart';
import '../../data/sources/budget_local_source.dart';

// Box provider
final budgetsBoxProvider = Provider<Box<double>>((ref) {
  return Hive.box<double>('monthly_budgets');
});

// Repo provider
final budgetRepositoryProvider = Provider<BudgetRepositoryImpl>((ref) {
  final box = ref.watch(budgetsBoxProvider);
  return BudgetRepositoryImpl(BudgetLocalSource(box));
});

// Watch a specific month’s budget
final budgetForMonthProvider = StreamProvider.family<double?, DateTime>((
  ref,
  monthKey,
) {
  final repo = ref.watch(budgetRepositoryProvider);
  return repo.watchBudget(monthKey.year, monthKey.month);
});

// Controller to set/update
class BudgetController extends StateNotifier<AsyncValue<void>> {
  BudgetController(this._repo) : super(const AsyncData(null));
  final BudgetRepositoryImpl _repo;

  Future<void> setBudget(DateTime monthKey, double amount) async {
    state = const AsyncLoading();
    try {
      await _repo.setBudget(monthKey.year, monthKey.month, amount);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final budgetControllerProvider =
    StateNotifierProvider<BudgetController, AsyncValue<void>>((ref) {
      return BudgetController(ref.watch(budgetRepositoryProvider));
    });
