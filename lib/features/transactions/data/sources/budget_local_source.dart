import 'package:hive/hive.dart';

class BudgetLocalSource {
  BudgetLocalSource(this._box);
  final Box<double> _box;

  String _key(int year, int month) =>
      '$year-${month.toString().padLeft(2, '0')}';

  double? get(int year, int month) => _box.get(_key(year, month));

  Future<void> set(int year, int month, double amount) async {
    await _box.put(_key(year, month), amount);
  }

  // Emits whenever any budget changes, then maps to the month you care about
  Stream<double?> watch(int year, int month) {
    final k = _key(year, month);
    // initial + updates
    final initial = Stream<double?>.value(_box.get(k));
    final updates = _box.watch().map((_) => _box.get(k));
    return initial.asyncExpand((v) async* {
      yield v;
      yield* updates;
    });
  }
}
