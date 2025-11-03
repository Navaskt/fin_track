import 'package:hive/hive.dart';
import 'transaction_model.dart';

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 1;

  @override
  TransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return TransactionModel(
      id: fields[0] as String,
      amount: fields[1] as double,
      category: fields[2] as String,
      note: fields[3] as String?,
      date: fields[4] as DateTime,
      receiptPath: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.note)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.receiptPath);
  }
}
