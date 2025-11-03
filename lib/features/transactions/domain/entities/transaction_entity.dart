class TransactionEntity {
  TransactionEntity({
    required this.id,
    required this.amount,
    required this.category,
    this.note,
    required this.date,
    this.receiptPath,
  });

  final String id;
  final double amount;
  final String category;
  final String? note;
  final DateTime date;
  final String? receiptPath;
}
