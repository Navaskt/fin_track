import 'dart:io';

import 'package:fin_track/app/extension/context_extension.dart';
import 'package:fin_track/core/extensions/spacing_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/helpers/receipt_image_service.dart';
import '../../../../core/helpers/receipt_ocr_service.dart';
import '../../domain/entities/transaction_entity.dart';
import '../controllers/transaction_providers.dart';
import '../widgets/amount_field.dart';
import '../widgets/bottom_action_bar.dart';
import '../widgets/category_field.dart';
import '../widgets/chip_button.dart';
import '../widgets/receipt_viewer.dart';
import '../widgets/section_card.dart';

enum TransactionType { expense, income }

// Default categories
const _expenseCategories = <String>[
  'Food',
  'Groceries',
  'Transport',
  'Taxi',
  'Bills',
  'Utilities',
  'Insurance',
  'Credit Card',
  'Credit',
  'Shopping',
  'Health',
  'Entertainment',
  'Rent',
  'Coffee',
  'Fuel',
  'Education',
  'Other',
];

const _incomeCategories = <String>[
  'Salary',
  'Bonus',
  'Interest',
  'Refund',
  'Gift',
  'Investment',
  'Incentive',
  'Other',
];

class AddEditPage extends ConsumerStatefulWidget {
  const AddEditPage({super.key, this.id});
  final String? id;

  @override
  ConsumerState<AddEditPage> createState() => _AddEditPageState();
}

class _AddEditPageState extends ConsumerState<AddEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  TransactionType _type = TransactionType.expense;
  late final bool _isEditMode;
  String? _receiptPath;
  bool _isScanningReceipt = false; 

  List<String> get _suggestions =>
      _type == TransactionType.expense ? _expenseCategories : _incomeCategories;

  void _pickQuickCategory(String c) {
    _categoryCtrl.text = c;
    HapticFeedback.selectionClick();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.id != null;
    if (_isEditMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final transaction = ref
            .read(transactionsStreamProvider)
            .maybeWhen(
              orElse: () => null,
              data: (items) => items.firstWhere((t) => t.id == widget.id),
            );
        if (transaction != null) {
          _amountCtrl.text = transaction.amount.abs().toString();
          _categoryCtrl.text = transaction.category;
          _noteCtrl.text = transaction.note ?? '';
          setState(() {
            _date = transaction.date;
            _type = transaction.amount.isNegative
                ? TransactionType.expense
                : TransactionType.income;
            _receiptPath = transaction.receiptPath;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _categoryCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final nextMonth = DateTime(now.year, now.month + 1, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: nextMonth,
    );
    if (picked != null && picked != _date) {
      setState(() => _date = picked);
    }
  }

  void _setToday() {
    setState(() => _date = DateTime.now());
  }

  void _setYesterday() {
    setState(
      () => _date = DateUtils.addDaysToDate(
        DateUtils.dateOnly(DateTime.now()),
        -1,
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final amount = double.parse(_amountCtrl.text);
    final finalAmount = _type == TransactionType.expense
        ? -amount.abs()
        : amount.abs();
    final note = _noteCtrl.text.trim();

    final transaction = TransactionEntity(
      id: widget.id ?? const Uuid().v4(),
      amount: finalAmount,
      category: _categoryCtrl.text.trim(),
      note: note.isEmpty ? null : note,
      date: _date,
      receiptPath: _receiptPath,
    );

    await ref
        .read(transactionControllerProvider.notifier)
        .addOrUpdate(transaction);
    if (mounted) Navigator.of(context).pop();
  }

  // Future<void> _pickReceipt(bool fromCamera) async {
  //   final path = await ReceiptImageService.pickAndSave(fromCamera: fromCamera);
  //   if (path != null) {
  //     // clean up old one if replacing
  //     if (_receiptPath != null) {
  //       await ReceiptImageService.deleteIfExists(_receiptPath);
  //     }
  //     setState(() => _receiptPath = path);
  //   }
  // }

  Future<void> _pickReceipt(bool fromCamera) async {
    final path = await ReceiptImageService.pickAndSave(fromCamera: fromCamera);
    if (path == null) return;

    if (_receiptPath != null) {
      await ReceiptImageService.deleteIfExists(_receiptPath);
    }
    setState(() => _receiptPath = path);

    await _runOcr(path);
  }

  Future<void> _runOcr(String path) async {
    setState(() => _isScanningReceipt = true);
    try {
      final result = await ReceiptOcrService.scan(path);
      if (!mounted) return;

      var filledSomething = false;

      if (result.amount != null && _amountCtrl.text.trim().isEmpty) {
        _amountCtrl.text = result.amount!.toStringAsFixed(2);
        filledSomething = true;
      }
      if (result.merchant != null && _noteCtrl.text.trim().isEmpty) {
        _noteCtrl.text = result.merchant!;
        filledSomething = true;
      }
      if (result.suggestedCategory != null &&
          _categoryCtrl.text.trim().isEmpty) {
        _categoryCtrl.text = result.suggestedCategory!;
        filledSomething = true;
      }

      if (filledSomething) {
        setState(() {}); // refresh chip selection state
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Helloo')));
      }
    } catch (_) {
      // OCR is best-effort — silently do nothing, user fills manually
    } finally {
      if (mounted) setState(() => _isScanningReceipt = false);
    }
  }

  void _removeReceipt() async {
    await ReceiptImageService.deleteIfExists(_receiptPath);
    setState(() => _receiptPath = null);
  }

  void _showFullReceipt(BuildContext context, String path) =>
      showFullReceipt(context, path);

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditMode
              ? context.loc.editTransactionTitle
              : context.loc.addTransactionTitle,
          style: t.titleLarge?.copyWith(color: cs.secondary),
        ),
      ),
      bottomNavigationBar: BottomActionBar(
        child: FilledButton(
          onPressed: _submit,
          child: Text(
            _isEditMode ? context.loc.updateButton : context.loc.saveButton,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: 16.padL + 12.padT + 16.padR + 120.padB,
            children: [
              // Type selector + amount card
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Segmented type with icons
                    SegmentedButton<TransactionType>(
                      segments: [
                        ButtonSegment(
                          value: TransactionType.expense,
                          icon: const Icon(Icons.remove_circle_outline),
                          label: Text(context.loc.expense),
                        ),
                        ButtonSegment(
                          value: TransactionType.income,
                          icon: const Icon(Icons.add_circle_outline),
                          label: Text(context.loc.income),
                        ),
                      ],
                      selected: {_type},
                      onSelectionChanged: (sel) {
                        HapticFeedback.selectionClick();
                        setState(() => _type = sel.first);
                      },
                    ),
                    16.hBox,

                    // Amount input - big and readable
                    Text(
                      context.loc.amountLabel,
                      style: t.labelLarge?.copyWith(color: cs.onSurfaceVariant),
                    ),
                    6.hBox,
                    AmountField(controller: _amountCtrl),
                  ],
                ),
              ),

              12.hBox,

              // Category card
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CategoryField(
                      controller: _categoryCtrl,
                      suggestions: _suggestions,
                    ),
                    10.hBox,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: 6.padR,
                      child: Row(
                        children: _suggestions.map((c) {
                          final selected =
                              _categoryCtrl.text.trim().toLowerCase() ==
                              c.toLowerCase();
                          return Padding(
                            padding: 8.padR,
                            child: ChoiceChip(
                              label: Text(c),
                              selected: selected,
                              onSelected: (_) => _pickQuickCategory(c),
                              selectedColor: cs.primaryContainer,
                              labelStyle: selected
                                  ? TextStyle(
                                      color: cs.onPrimaryContainer,
                                      fontWeight: FontWeight.w600,
                                    )
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              12.hBox,

              // Note + Date card
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Note
                    TextFormField(
                      controller: _noteCtrl,
                      decoration: InputDecoration(
                        labelText: context.loc.noteLabel,
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                    ),
                    16.hBox,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.loc.receiptLabel,
                          style: t.labelLarge?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        8.hBox,
                        if (_receiptPath != null)
                          Stack(
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    _showFullReceipt(context, _receiptPath!),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    File(_receiptPath!),
                                    height: 140,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              if (_isScanningReceipt)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black45,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: IconButton.filledTonal(
                                  icon: const Icon(Icons.close, size: 18),
                                  onPressed: _isScanningReceipt
                                      ? null
                                      : _removeReceipt,
                                ),
                              ),
                            ],
                          )
                        else
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  icon: const Icon(Icons.camera_alt_outlined),
                                  label: Text(context.loc.captureLabel),
                                  onPressed: () => _pickReceipt(true),
                                ),
                              ),
                              8.wBox,
                              Expanded(
                                child: OutlinedButton.icon(
                                  icon: const Icon(Icons.image_outlined),
                                  label: Text(context.loc.uploadLabel),
                                  onPressed: () => _pickReceipt(false),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    8.hBox,
                    // Date row with quick chips
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${context.loc.dateLabel}: ${DateFormat.yMMMd().format(_date)}',
                            style: t.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        4.wBox,
                        Expanded(
                          child: ChipButton(
                            text: context.loc.todayLabel,
                            onTap: _setToday,
                          ),
                        ),
                        4.wBox,
                        Expanded(
                          child: ChipButton(
                            text: context.loc.yesterdayLabel,
                            onTap: _setYesterday,
                          ),
                        ),
                        4.wBox,
                        Expanded(
                          child: ChipButton(
                            text: context.loc.pickDateButton,
                            onTap: _pickDate,
                            icon: Icons.event,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- UI bits ---
// All private widget classes have been moved to their own
