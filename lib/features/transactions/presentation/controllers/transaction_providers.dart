import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';

import '../../data/models/transaction_model.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../data/sources/transaction_local_source.dart';
import '../../domain/entities/transaction_entity.dart';

final transactionsBoxProvider = Provider<Box<TransactionModel>>((ref) {
  return Hive.box<TransactionModel>('transactions');
});

final transactionRepositoryProvider = Provider<TransactionRepositoryImpl>((
  ref,
) {
  final box = ref.watch(transactionsBoxProvider);
  return TransactionRepositoryImpl(TransactionLocalSource(box));
});

final transactionsStreamProvider = StreamProvider<List<TransactionEntity>>((
  ref,
) {
  return ref.watch(transactionRepositoryProvider).watchAll();
});

class TransactionController extends StateNotifier<AsyncValue<void>> {
  TransactionController(this._repo) : super(const AsyncData(null));
  final TransactionRepositoryImpl _repo;

  Future<void> addOrUpdate(TransactionEntity e) async {
    state = const AsyncLoading();
    try {
      await _repo.upsert(e);
      state = const AsyncData(null);
    } catch (error, stack) {
      state = AsyncError(error, stack);
    }
  }

  Future<void> delete(String id) async {
    state = const AsyncLoading();
    try {
      await _repo.delete(id);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // in transaction_controller_provider.dart (or similar)
  Future<void> updateNote(String id, String? note) async {
    state = const AsyncLoading();
    try {
      // load existing entity from repository
      final current = _repo.getById(id);
      if (current == null) {
        throw Exception('Transaction with id $id not found');
      }

      final updated = current.copyWith(note: note);
      // update in Hive / repo
      await _repo.upsert(updated);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final transactionControllerProvider =
    StateNotifierProvider<TransactionController, AsyncValue<void>>((ref) {
      return TransactionController(ref.watch(transactionRepositoryProvider));
    });
