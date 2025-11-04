// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionModelImpl _$$TransactionModelImplFromJson(
  Map<String, dynamic> json,
) => _$TransactionModelImpl(
  id: json['id'] as String,
  amount: (json['amount'] as num).toDouble(),
  category: json['category'] as String,
  note: json['note'] as String?,
  date: DateTime.parse(json['date'] as String),
  receiptPath: json['receiptPath'] as String?,
);

Map<String, dynamic> _$$TransactionModelImplToJson(
  _$TransactionModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'amount': instance.amount,
  'category': instance.category,
  'note': instance.note,
  'date': instance.date.toIso8601String(),
  'receiptPath': instance.receiptPath,
};
