import 'package:fin_track/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/transaction_entity.dart';
import '../controllers/transaction_providers.dart';
import '../widgets/amount_field.dart';
import '../widgets/bottom_action_bar.dart';
import '../widgets/category_field.dart';
import '../widgets/chip_button.dart';
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
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
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
    );

    await ref
        .read(transactionControllerProvider.notifier)
        .addOrUpdate(transaction);
    if (mounted) Navigator.of(context).pop();
  }

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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
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
                  const SizedBox(height: 16),

                  // Amount input - big and readable
                  Text(
                    context.loc.amountLabel,
                    style: t.labelLarge?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 6),
                  AmountField(controller: _amountCtrl),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Category card
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryField(
                    controller: _categoryCtrl,
                    suggestions: _suggestions,
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(right: 6),
                    child: Row(
                      children: _suggestions.map((c) {
                        final selected =
                            _categoryCtrl.text.trim().toLowerCase() ==
                            c.toLowerCase();
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
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

            const SizedBox(height: 12),

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
                  const SizedBox(height: 16),

                  // Date row with quick chips
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${context.loc.dateLabel}: ${DateFormat.yMMMd().format(_date)}',
                          style: t.bodyMedium,
                        ),
                      ),
                      Wrap(
                        spacing: 8,
                        children: [
                          ChipButton(
                            text: context.loc.todayLabel,
                            onTap: _setToday,
                          ),
                          ChipButton(
                            text: context.loc.yesterdayLabel,
                            onTap: _setYesterday,
                          ),
                          ChipButton(
                            text: context.loc.pickDateButton,
                            onTap: _pickDate,
                            icon: Icons.event,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- UI bits ---
// All private widget classes have been moved to their own
