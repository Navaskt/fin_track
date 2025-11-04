import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'transaction_model.freezed.dart'; 
part 'transaction_model.g.dart';   

@freezed
class TransactionModel with _$TransactionModel {
  @HiveType(typeId: 1, adapterName: 'TransactionModelAdapter')
  const factory TransactionModel({
    @HiveField(0) required String id,
    @HiveField(1) required double amount,
    @HiveField(2) required String category,
    @HiveField(3) String? note,
    @HiveField(4) required DateTime date,
    @HiveField(5) String? receiptPath,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);
}