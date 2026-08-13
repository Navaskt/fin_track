import 'dart:io';
import 'dart:ui';

import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show rootBundle, Uint8List;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../transactions/data/models/transaction_model.dart';

class ExportService {
  ExportService(this.txBox);
  final Box<TransactionModel> txBox;

  late final pw.Font _fontBase;
  late final pw.Font _fontBold;
  bool _fontsLoaded = false;

  Future<void> _ensureFonts(Locale? locale) async {
    if (_fontsLoaded) return;

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

  // ─── PDF Export ────────────────────────────────────────────────────────────

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
    final amountFmt = NumberFormat.currency(
      locale: locale?.toString(),
      symbol: '',
      decimalDigits: 2,
    );

    final incomeRows = <TransactionModel>[];
    final expenseRows = <TransactionModel>[];
    var totalIncome = 0.0;
    var totalExpense = 0.0;

    for (final t in rows) {
      if (t.amount >= 0) {
        incomeRows.add(t);
        totalIncome += t.amount;
      } else {
        expenseRows.add(t);
        totalExpense += t.amount.abs();
      }
    }
    final netBalance = totalIncome - totalExpense;

    final doc = pw.Document(
      theme: pw.ThemeData.withFont(base: _fontBase, bold: _fontBold),
    );

    final isRtl = (locale?.languageCode ?? '').toLowerCase() == 'ar';

    doc.addPage(
      pw.MultiPage(
        textDirection: isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(24.r),
        build: (context) => [
          pw.Text(
            'FinTrack Report',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6.h),
          pw.Text('Period: ${dateFmt.format(from)} - ${dateFmt.format(to)}'),
          pw.SizedBox(height: 2.h),
          pw.Text(currencyNote, style: const pw.TextStyle(fontSize: 10)),
          pw.SizedBox(height: 14.h),
          _buildSummaryRow(totalIncome, totalExpense, netBalance, amountFmt),
          pw.SizedBox(height: 18.h),
          if (incomeRows.isNotEmpty) ...[
            _sectionHeader('Income', totalIncome, amountFmt, PdfColors.green800),
            pw.SizedBox(height: 4.h),
            _transactionTable(incomeRows, dateFmt, amountFmt, isIncome: true),
            pw.SizedBox(height: 16.h),
          ],
          if (expenseRows.isNotEmpty) ...[
            _sectionHeader('Expenses', totalExpense, amountFmt, PdfColors.red800),
            pw.SizedBox(height: 4.h),
            _transactionTable(expenseRows, dateFmt, amountFmt, isIncome: false),
          ],
          if (rows.isEmpty) ...[
            pw.SizedBox(height: 20.h),
            pw.Text(
              'No transactions in this period.',
              style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey600),
            ),
          ],
        ],
      ),
    );

    final file = await _createFile(fileName);
    await file.writeAsBytes(await doc.save());
    return file.path;
  }

  // ─── Excel Export ───────────────────────────────────────────────────────────

  Future<String> exportExcel({
    required DateTime from,
    required DateTime to,
    String fileName = 'fintrack_export.xlsx',
    Locale? locale,
  }) async {
    final rows = await _rows(from: from, to: to);
    final dateFmt = DateFormat('yyyy-MM-dd');
    final amountFmt = NumberFormat.currency(
      locale: locale?.toString(),
      symbol: '',
      decimalDigits: 2,
    );

    final excel = Excel.createExcel();

    // Remove the default "Sheet1" that Excel.createExcel() always adds
    excel.delete('Sheet1');

    // Shared cell styles
    final headerStyle = CellStyle(
      bold: true,
      backgroundColorHex: ExcelColor.fromHexString('#1E3A5F'),
      fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
      horizontalAlign: HorizontalAlign.Center,
    );
    final incomeAmountStyle = CellStyle(
      fontColorHex: ExcelColor.fromHexString('#1B5E20'),
      bold: true,
      horizontalAlign: HorizontalAlign.Right,
    );
    final expenseAmountStyle = CellStyle(
      fontColorHex: ExcelColor.fromHexString('#B71C1C'),
      bold: true,
      horizontalAlign: HorizontalAlign.Right,
    );
    final totalLabelStyle = CellStyle(
      bold: true,
      backgroundColorHex: ExcelColor.fromHexString('#F5F5F5'),
    );
    final totalValueStyle = CellStyle(
      bold: true,
      backgroundColorHex: ExcelColor.fromHexString('#F5F5F5'),
      horizontalAlign: HorizontalAlign.Right,
    );
    final subHeaderStyle = CellStyle(
      bold: true,
      italic: true,
      backgroundColorHex: ExcelColor.fromHexString('#E8EAF6'),
    );

    // Split income / expense and compute totals in one pass
    final incomeRows = <TransactionModel>[];
    final expenseRows = <TransactionModel>[];
    var totalIncome = 0.0;
    var totalExpense = 0.0;

    for (final t in rows) {
      if (t.amount >= 0) {
        incomeRows.add(t);
        totalIncome += t.amount;
      } else {
        expenseRows.add(t);
        totalExpense += t.amount.abs();
      }
    }
    final netBalance = totalIncome - totalExpense;

    // ── Sheet 1: Summary ────────────────────────────────────────────────────
    final summarySheet = excel['Summary'];
    _buildSummarySheet(
      sheet: summarySheet,
      from: from,
      to: to,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      netBalance: netBalance,
      dateFmt: dateFmt,
      amountFmt: amountFmt,
      headerStyle: headerStyle,
      totalLabelStyle: totalLabelStyle,
      totalValueStyle: totalValueStyle,
    );

    // ── Sheet 2: Transactions (all, income + expense interleaved) ───────────
    final allSheet = excel['All Transactions'];
    _buildTransactionSheet(
      sheet: allSheet,
      items: rows,
      dateFmt: dateFmt,
      amountFmt: amountFmt,
      headerStyle: headerStyle,
      incomeAmountStyle: incomeAmountStyle,
      expenseAmountStyle: expenseAmountStyle,
      subHeaderStyle: subHeaderStyle,
    );

    // ── Sheet 3: Income only ────────────────────────────────────────────────
    if (incomeRows.isNotEmpty) {
      final incomeSheet = excel['Income'];
      _buildSectionSheet(
        sheet: incomeSheet,
        items: incomeRows,
        isIncome: true,
        total: totalIncome,
        dateFmt: dateFmt,
        amountFmt: amountFmt,
        headerStyle: headerStyle,
        amountStyle: incomeAmountStyle,
        totalLabelStyle: totalLabelStyle,
        totalValueStyle: totalValueStyle,
      );
    }

    // ── Sheet 4: Expenses only ──────────────────────────────────────────────
    if (expenseRows.isNotEmpty) {
      final expenseSheet = excel['Expenses'];
      _buildSectionSheet(
        sheet: expenseSheet,
        items: expenseRows,
        isIncome: false,
        total: totalExpense,
        dateFmt: dateFmt,
        amountFmt: amountFmt,
        headerStyle: headerStyle,
        amountStyle: expenseAmountStyle,
        totalLabelStyle: totalLabelStyle,
        totalValueStyle: totalValueStyle,
      );
    }

    // Set Summary as the active sheet on open
    excel.setDefaultSheet('Summary');

    final file = await _createFile(fileName);
    final bytes = excel.save();
    if (bytes == null) throw Exception('Failed to encode Excel workbook');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  // ─── Excel sheet builders ───────────────────────────────────────────────────

  void _buildSummarySheet({
    required Sheet sheet,
    required DateTime from,
    required DateTime to,
    required double totalIncome,
    required double totalExpense,
    required double netBalance,
    required DateFormat dateFmt,
    required NumberFormat amountFmt,
    required CellStyle headerStyle,
    required CellStyle totalLabelStyle,
    required CellStyle totalValueStyle,
  }) {
    // Title
    sheet.cell(CellIndex.indexByString('A1')).value = TextCellValue('FinTrack Report');

    sheet.cell(CellIndex.indexByString('A1')).cellStyle = CellStyle(bold: true);

    sheet.cell(CellIndex.indexByString('A2')).value = TextCellValue(
      'Period: ${dateFmt.format(from)} — ${dateFmt.format(to)}',
    );

    // Blank row
    // Headers row 4
    _setCellWithStyle(sheet, 'A4', 'Metric', headerStyle);
    _setCellWithStyle(sheet, 'B4', 'Amount', headerStyle);

    // Data rows
    _setCellWithStyle(sheet, 'A5', 'Total Income', totalLabelStyle);
    _setCellWithStyle(sheet, 'B5', amountFmt.format(totalIncome),
        CellStyle(
          fontColorHex: ExcelColor.fromHexString('#1B5E20'),
          bold: true,
          horizontalAlign: HorizontalAlign.Right,
          backgroundColorHex: ExcelColor.fromHexString('#F5F5F5'),
        ));

    _setCellWithStyle(sheet, 'A6', 'Total Expenses', totalLabelStyle);
    _setCellWithStyle(sheet, 'B6', amountFmt.format(totalExpense),
        CellStyle(
          fontColorHex: ExcelColor.fromHexString('#B71C1C'),
          bold: true,
          horizontalAlign: HorizontalAlign.Right,
          backgroundColorHex: ExcelColor.fromHexString('#F5F5F5'),
        ));

    _setCellWithStyle(sheet, 'A7', 'Net Balance', totalLabelStyle);
    _setCellWithStyle(
      sheet,
      'B7',
      amountFmt.format(netBalance),
      CellStyle(
        fontColorHex: ExcelColor.fromHexString(
          netBalance >= 0 ? '#1B5E20' : '#B71C1C',
        ),
        bold: true,
        horizontalAlign: HorizontalAlign.Right,
        backgroundColorHex: ExcelColor.fromHexString('#F5F5F5'),
      ),
    );

    // Column widths
    sheet.setColumnWidth(0, 24);
    sheet.setColumnWidth(1, 20);
  }

  void _buildTransactionSheet({
    required Sheet sheet,
    required List<TransactionModel> items,
    required DateFormat dateFmt,
    required NumberFormat amountFmt,
    required CellStyle headerStyle,
    required CellStyle incomeAmountStyle,
    required CellStyle expenseAmountStyle,
    required CellStyle subHeaderStyle,
  }) {
    // Headers
    const headers = ['Date', 'Type', 'Category', 'Note', 'Amount'];
    for (var i = 0; i < headers.length; i++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;
    }

    for (var i = 0; i < items.length; i++) {
      final t = items[i];
      final isIncome = t.amount >= 0;
      final rowIndex = i + 1;

      _setRowCell(sheet, rowIndex, 0, dateFmt.format(t.date));
      _setRowCell(sheet, rowIndex, 1, isIncome ? 'Income' : 'Expense');
      _setRowCell(sheet, rowIndex, 2, t.category);
      _setRowCell(sheet, rowIndex, 3, t.note ?? '');

      final amountCell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex),
      );
      amountCell.value = TextCellValue(
        '${isIncome ? '+' : '-'}${amountFmt.format(t.amount.abs())}',
      );
      amountCell.cellStyle =
          isIncome ? incomeAmountStyle : expenseAmountStyle;
    }

    // Column widths
    sheet.setColumnWidth(0, 14);
    sheet.setColumnWidth(1, 10);
    sheet.setColumnWidth(2, 18);
    sheet.setColumnWidth(3, 30);
    sheet.setColumnWidth(4, 16);
  }

  void _buildSectionSheet({
    required Sheet sheet,
    required List<TransactionModel> items,
    required bool isIncome,
    required double total,
    required DateFormat dateFmt,
    required NumberFormat amountFmt,
    required CellStyle headerStyle,
    required CellStyle amountStyle,
    required CellStyle totalLabelStyle,
    required CellStyle totalValueStyle,
  }) {
    // Headers
    const headers = ['Date', 'Category', 'Note', 'Amount'];
    for (var i = 0; i < headers.length; i++) {
      final cell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
      );
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;
    }

    final sign = isIncome ? '+' : '-';
    for (var i = 0; i < items.length; i++) {
      final t = items[i];
      final rowIndex = i + 1;

      _setRowCell(sheet, rowIndex, 0, dateFmt.format(t.date));
      _setRowCell(sheet, rowIndex, 1, t.category);
      _setRowCell(sheet, rowIndex, 2, t.note ?? '');

      final amountCell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex),
      );
      amountCell.value =
          TextCellValue('$sign${amountFmt.format(t.amount.abs())}');
      amountCell.cellStyle = amountStyle;
    }

    // Total row (one blank row gap)
    final totalRow = items.length + 2;
    _setCellWithStyle(
      sheet,
      _cellRef(0, totalRow),
      isIncome ? 'Total Income' : 'Total Expenses',
      totalLabelStyle,
    );
    _setCellWithStyle(
      sheet,
      _cellRef(3, totalRow),
      amountFmt.format(total),
      totalValueStyle,
    );

    // Column widths
    sheet.setColumnWidth(0, 14);
    sheet.setColumnWidth(1, 18);
    sheet.setColumnWidth(2, 30);
    sheet.setColumnWidth(3, 16);
  }

  // ─── PDF building helpers (unchanged) ──────────────────────────────────────

  pw.Widget _buildSummaryRow(
    double income,
    double expense,
    double net,
    NumberFormat fmt,
  ) {
    final netColor = net >= 0 ? PdfColors.green800 : PdfColors.red800;
    return pw.Row(
      children: [
        pw.Expanded(child: _statCard('Total Income', fmt.format(income), PdfColors.green800)),
        pw.SizedBox(width: 8.w),
        pw.Expanded(child: _statCard('Total Expense', fmt.format(expense), PdfColors.red800)),
        pw.SizedBox(width: 8.w),
        pw.Expanded(child: _statCard('Net Balance', fmt.format(net), netColor)),
      ],
    );
  }

  pw.Widget _statCard(String label, String value, PdfColor valueColor) {
    return pw.Container(
      padding: pw.EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey300,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
          pw.SizedBox(height: 3.h),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: valueColor),
          ),
        ],
      ),
    );
  }

  pw.Widget _sectionHeader(String title, double total, NumberFormat fmt, PdfColor color) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(title, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
        pw.Text(
          fmt.format(total),
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: color),
        ),
      ],
    );
  }

  pw.Widget _transactionTable(
    List<TransactionModel> items,
    DateFormat dateFmt,
    NumberFormat amountFmt, {
    required bool isIncome,
  }) {
    final color = isIncome ? PdfColors.green800 : PdfColors.red800;
    final sign = isIncome ? '+' : '-';

    return pw.TableHelper.fromTextArray(
      headers: const ['Date', 'Category', 'Note', 'Amount'],
      data: items.map((t) {
        return [
          dateFmt.format(t.date),
          t.category,
          t.note ?? '',
          '$sign${amountFmt.format(t.amount.abs())}',
        ];
      }).toList(),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellAlignment: pw.Alignment.centerLeft,
      cellStyle: const pw.TextStyle(fontSize: 10),
      cellAlignments: {3: pw.Alignment.centerRight},
      columnWidths: const {
        0: pw.FlexColumnWidth(1.4),
        1: pw.FlexColumnWidth(1.6),
        2: pw.FlexColumnWidth(2.4),
        3: pw.FlexColumnWidth(1.4),
      },
      textStyleBuilder: (index, data, rowNum) =>
          index == 3 ? pw.TextStyle(fontSize: 10, color: color) : null,
    );
  }

  // ─── Share ──────────────────────────────────────────────────────────────────

  Future<void> shareFile(String path, {String? text, Uint8List? bytes}) async {
    if (path.endsWith('.pdf')) {
      final data = bytes ?? await File(path).readAsBytes();
      await Printing.sharePdf(bytes: data, filename: path.split('/').last);
      return;
    }
    if (kIsWeb) {
      await SharePlus.instance.share(ShareParams(text: 'Download: $path\n${text ?? ''}'));
      return;
    }
    final xFile = XFile(path, mimeType: _guessMime(path));
    await SharePlus.instance.share(ShareParams(files: [xFile], text: text));
  }

  // ─── Internals ──────────────────────────────────────────────────────────────

  Future<List<TransactionModel>> _rows({
    required DateTime from,
    required DateTime to,
  }) async {
    final start = DateTime(from.year, from.month, from.day);
    final end = DateTime(to.year, to.month, to.day, 23, 59, 59, 999);

    final list = txBox.values
        .where((t) => !t.date.isBefore(start) && !t.date.isAfter(end))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

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
    if (path.endsWith('.xlsx')) {
      return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
    }
    return 'application/octet-stream';
  }

  // ─── Excel cell helpers ─────────────────────────────────────────────────────

  void _setCellWithStyle(Sheet sheet, String ref, String value, CellStyle style) {
    final cell = sheet.cell(CellIndex.indexByString(ref));
    cell.value = TextCellValue(value);
    cell.cellStyle = style;
  }

  void _setRowCell(Sheet sheet, int row, int col, String value) {
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row))
        .value = TextCellValue(value);
  }

  /// Converts zero-based [col] + [row] to an A1-style cell reference (e.g. 'D7').
  String _cellRef(int col, int row) {
    // Supports up to 26 columns (A–Z), which is plenty for this report.
    final colLetter = String.fromCharCode('A'.codeUnitAt(0) + col);
    return '$colLetter${row + 1}';
  }
}