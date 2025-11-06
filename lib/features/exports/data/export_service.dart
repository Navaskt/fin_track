import 'dart:io';
import 'dart:ui';

import 'package:flutter/services.dart' show rootBundle, Uint8List;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../transactions/data/models/transaction_model.dart';

// ...

class ExportService {
  ExportService(this.txBox);
  final Box<TransactionModel> txBox;

  late final pw.Font _fontBase;
  late final pw.Font _fontBold;
  late bool _fontsLoaded = false;

  Future<void> _ensureFonts(Locale? locale) async {
    if (_fontsLoaded) return;

    // Pick script-aware fonts by locale
    final lang = (locale?.languageCode ?? 'en').toLowerCase();
    Future<pw.Font> ttf(String path) async =>
        pw.Font.ttf(await rootBundle.load(path));

    if (lang == 'ar') {
      _fontBase = await ttf('assets/fonts/NotoSansArabic-Regular.ttf');
      _fontBold = await ttf('assets/fonts/NotoSansArabic-Bold.ttf');
    } else if (lang == 'ml') {
      _fontBase = await ttf('assets/fonts/NotoSansMalayalam-Regular.ttf');
      _fontBold = await ttf('assets/fonts/NotoSansMalayalam-Bold.ttf');
    } else if (lang == 'hi') {
      _fontBase = await ttf('assets/fonts/NotoSansDevanagari-Regular.ttf');
      _fontBold = await ttf('assets/fonts/NotoSansDevanagari-Bold.ttf');
    } else {
      _fontBase = await ttf('assets/fonts/NotoSans-Regular.ttf');
      _fontBold = await ttf('assets/fonts/NotoSans-Bold.ttf');
    }
    _fontsLoaded = true;
  }

  Future<String> exportPdf({
    required DateTime from,
    required DateTime to,
    String fileName = 'fintrack_export.pdf',
    String currencyNote = 'Amounts shown in original currency',
    Locale? locale,
  }) async {
    await _ensureFonts(locale);

    final rows = await _rows(from: from, to: to);
    final dateFmt = DateFormat('yyyy-MM-dd');
    final totals = <String, int>{};

    final doc = pw.Document(
      theme: pw.ThemeData.withFont(base: _fontBase, bold: _fontBold),
    );

    final isRtl = (locale?.languageCode ?? '').toLowerCase() == 'ar';

    doc.addPage(
      pw.MultiPage(
        textDirection: isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          pw.Text(
            'FinTrack Report',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          pw.Text('Period: ${dateFmt.format(from)} - ${dateFmt.format(to)}'),
          pw.SizedBox(height: 2),
          pw.Text(currencyNote, style: const pw.TextStyle(fontSize: 10)),
          pw.SizedBox(height: 12),
          if (totals.isNotEmpty) ...[
            pw.Text(
              'Totals',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 4),
            pw.Table.fromTextArray(
              headers: ['Currency', 'Total'],
              data: totals.entries
                  .map((e) => [e.key, (e.value / 100.0).toStringAsFixed(2)])
                  .toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellAlignment: pw.Alignment.centerLeft,
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey300,
              ),
            ),
            pw.SizedBox(height: 16),
          ],
          pw.Text(
            'Transactions',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Table.fromTextArray(
            headers: const ['Date', 'Category', 'Note', 'Amount'],
            data: rows.map((t) {
              return [
                dateFmt.format(t.date),
                t.category,
                t.note ?? '',
                (t.amount / 100.0).toStringAsFixed(2),
              ];
            }).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            cellAlignment: pw.Alignment.centerLeft,
            cellStyle: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );

    final file = await _createFile(fileName);
    await file.writeAsBytes(await doc.save());
    return file.path;
  }

  // shareFile below updated
  Future<void> shareFile(String path, {String? text, Uint8List? bytes}) async {
    // Prefer printing’s share (works on iOS/Android/macOS/web)
    if (path.endsWith('.pdf')) {
      final data = bytes ?? await File(path).readAsBytes();
      await Printing.sharePdf(bytes: data, filename: path.split('/').last);
      return;
    }
    // CSV: use share_plus if available, fall back to simple text share on web
    if (kIsWeb) {
      await Share.share('Download: $path\n${text ?? ''}');
      return;
    }
    final xFile = XFile(path, mimeType: _guessMime(path));
    await Share.shareXFiles([xFile], text: text);
  }

  // --- internals ---

  Future<List<TransactionModel>> _rows({
    required DateTime from,
    required DateTime to,
  }) async {
    final start = DateTime(from.year, from.month, from.day);
    final end = DateTime(to.year, to.month, to.day, 23, 59, 59, 999);

    final list = <TransactionModel>[];
    for (final key in txBox.keys) {
      final t = txBox.get(key);
      if (t == null) continue;
      if (t.date.isBefore(start) || t.date.isAfter(end)) continue;
      list.add(t);
    }

    // Sort by date ascending
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  Future<File> _createFile(String fileName) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    if (await file.exists()) await file.delete();
    return file.create(recursive: true);
  }

  String _guessMime(String path) {
    if (path.endsWith('.csv')) return 'text/csv';
    if (path.endsWith('.pdf')) return 'application/pdf';
    return 'application/octet-stream';
  }
}
