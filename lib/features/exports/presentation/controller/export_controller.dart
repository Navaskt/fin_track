import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../../transactions/data/models/transaction_model.dart';
import '../../data/export_service.dart';

final exportServiceProvider = Provider<ExportService>((ref) {
  // Ensure you have the box opened in main() as Box<TransactionModel>('transactions')
  final box = Hive.box<TransactionModel>('transactions');
  return ExportService(box);
});

final exportControllerProvider = Provider<ExportController>((ref) {
  final svc = ref.read(exportServiceProvider);
  return ExportController(svc);
});

class ExportController {
  ExportController(this._svc);
  final ExportService _svc;

  Future<void> exportCsvAndShare(DateTimeRange range) async {
    final path = await _svc.exportPdf(from: range.start, to: range.end);
    await _svc.shareFile(path, text: 'FinTrack CSV Export');
  }

  Future<void> exportPdfAndShare(DateTimeRange range, {Locale? locale}) async {
    final path = await _svc.exportPdf(
      from: range.start,
      to: range.end,
      locale: locale,
    );
    await _svc.shareFile(path, text: 'FinTrack PDF Report');
  }
}
