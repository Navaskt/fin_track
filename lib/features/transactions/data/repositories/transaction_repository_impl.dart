import '../../domain/entities/transaction_entity.dart';
import '../models/transaction_model.dart';
import '../sources/transaction_local_source.dart';

class TransactionRepositoryImpl {
  TransactionRepositoryImpl(this._local);
  final TransactionLocalSource _local;

  Stream<List<TransactionEntity>> watchAll() =>
      _local.watchAll().map((items) => items.map(_toEntity).toList());

  List<TransactionEntity> getAll() => _local.getAll().map(_toEntity).toList();

  Future<void> upsert(TransactionEntity e) async {
    final m = TransactionModel(
      id: e.id,
      amount: e.amount,
      category: e.category,
      note: e.note,
      date: e.date,
      receiptPath: e.receiptPath,
    );
    await _local.upsert(m);
  }

  Future<void> delete(String id) => _local.delete(id);

  TransactionEntity? getById(String id) {
    final m = _local.getById(id);
    return m == null ? null : _toEntity(m);
  }

  TransactionEntity _toEntity(TransactionModel m) => TransactionEntity(
    id: m.id,
    amount: m.amount,
    category: m.category,
    note: m.note,
    date: m.date,
    receiptPath: m.receiptPath,
  );
}
