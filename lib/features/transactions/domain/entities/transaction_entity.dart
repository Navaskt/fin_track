import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_entity.freezed.dart';

@freezed
abstract class TransactionEntity with _$TransactionEntity {
  const factory TransactionEntity({
    required String id,
    required double amount,
    required String category,
    String? note,
    required DateTime date,
    String? receiptPath,
  }) = _TransactionEntity;
}
