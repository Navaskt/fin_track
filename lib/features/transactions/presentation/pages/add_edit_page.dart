import 'package:fin_track/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/transaction_entity.dart';
import '../controllers/transaction_providers.dart';

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

  List<String> get _suggestions {
    final base = _type == TransactionType.expense
        ? _expenseCategories
        : _incomeCategories;
    final seen = <String>{};
    return [
      for (final c in base)
        if (seen.add(c)) c,
    ];
  }

  void _pickQuickCategory(String c) {
    _categoryCtrl.text = c;
    FocusScope.of(context).nextFocus();
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
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditMode
              ? context.loc.editTransactionTitle
              : context.loc.addTransactionTitle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Expense / Income
              SegmentedButton<TransactionType>(
                segments: [
                  ButtonSegment(
                    value: TransactionType.expense,
                    label: Text(context.loc.expense),
                  ),
                  ButtonSegment(
                    value: TransactionType.income,
                    label: Text(context.loc.income),
                  ),
                ],
                selected: {_type},
                onSelectionChanged: (newSelection) {
                  setState(() {
                    _type = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Amount
              TextFormField(
                controller: _amountCtrl,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(labelText: context.loc.amountLabel),
                validator: (v) {
                  if (v == null || v.isEmpty) return context.loc.amountError;
                  final value = double.tryParse(v);
                  if (value == null || value <= 0) {
                    return context.loc.positiveAmountError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Category with autocomplete + quick chips
              _CategoryField(
                controller: _categoryCtrl,
                suggestions: _suggestions,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _suggestions.map((c) {
                  final selected =
                      _categoryCtrl.text.trim().toLowerCase() ==
                      c.toLowerCase();
                  return ChoiceChip(
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
                  );
                }).toList(),
              ),

              const SizedBox(height: 12),

              // Note
              TextFormField(
                controller: _noteCtrl,
                decoration: InputDecoration(
                  labelText: context.loc.noteLabel,
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),

              // Date
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${context.loc.dateLabel}: ${DateFormat.yMMMd().format(_date)}',
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: Text(context.loc.pickDateButton),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Save / Update
              FilledButton(
                onPressed: _submit,
                child: Text(
                  _isEditMode
                      ? context.loc.updateButton
                      : context.loc.saveButton,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Replace your _CategoryField with this version
class _CategoryField extends StatelessWidget {
  const _CategoryField({required this.controller, required this.suggestions});

  final TextEditingController controller;
  final List<String> suggestions;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue value) {
        final q = value.text.trim().toLowerCase();
        if (q.isEmpty) return const Iterable<String>.empty();
        return suggestions.where((c) => c.toLowerCase().contains(q));
      },

      fieldViewBuilder:
          (context, _ignoredCtrlFromAutocomplete, focusNode, onFieldSubmitted) {
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(labelText: context.loc.categoryLabel),
              validator: (v) => (v?.trim().isEmpty ?? true)
                  ? context.loc.categoryError
                  : null,
              onFieldSubmitted: (_) => onFieldSubmitted(),
            );
          },

      onSelected: (value) {
        controller.text = value;
      },

      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 240, maxWidth: 320),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: options.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final opt = options.elementAt(index);
                  return ListTile(
                    title: Text(opt),
                    onTap: () => onSelected(opt),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
