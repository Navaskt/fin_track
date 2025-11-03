import 'package:hive/hive.dart';

import '../models/transaction_model.dart';

class TransactionLocalSource {
  TransactionLocalSource(this._box);
  final Box<TransactionModel> _box;

  List<TransactionModel> getAll() => _box.values.toList()
    ..sort((a, b) => b.date.compareTo(a.date));

  Future<void> upsert(TransactionModel model) => _box.put(model.id, model);

  Future<void> delete(String id) => _box.delete(id);

  TransactionModel? getById(String id) => _box.get(id);

  Stream<List<TransactionModel>> watchAll() async* {
    yield getAll();
    yield* _box.watch().map((_) => getAll());
  }
}