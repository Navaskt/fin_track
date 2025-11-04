import '../sources/budget_local_source.dart';

class BudgetRepositoryImpl {
  BudgetRepositoryImpl(this._local);
  final BudgetLocalSource _local;

  double? getBudget(int year, int month) => _local.get(year, month);

  Stream<double?> watchBudget(int year, int month) => _local.watch(year, month);

  Future<void> setBudget(int year, int month, double amount) =>
      _local.set(year, month, amount);
}
