import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/transaction_entity.dart';
import '../controllers/transaction_providers.dart';

enum TransactionType { expense, income }

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
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.id != null;
    if (_isEditMode) {
      // Use a post-frame callback to access the provider safely in initState
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final transaction = ref
            .read(transactionsStreamProvider)
            .maybeWhen(
              data: (items) => items.firstWhere((t) => t.id == widget.id),
              orElse: () => null,
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
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _date) {
      setState(() => _date = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountCtrl.text);
    final finalAmount = _type == TransactionType.expense
        ? -amount.abs()
        : amount.abs();

    final transaction = TransactionEntity(
      id: widget.id ?? const Uuid().v4(),
      amount: finalAmount,
      category: _categoryCtrl.text.trim(),
      note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
      date: _date,
    );

    await ref
        .read(transactionControllerProvider.notifier)
        .addOrUpdate(transaction);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Transaction' : 'Add Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SegmentedButton<TransactionType>(
                segments: const [
                  ButtonSegment(
                    value: TransactionType.expense,
                    label: Text('Expense'),
                  ),
                  ButtonSegment(
                    value: TransactionType.income,
                    label: Text('Income'),
                  ),
                ],
                selected: {_type},
                onSelectionChanged: (newSelection) {
                  setState(() => _type = newSelection.first);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Amount (AED)'),
                validator: (v) {
                  final value = double.tryParse(v ?? '');
                  if (value == null || value <= 0) return 'Enter a valid amount';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoryCtrl,
                decoration: const InputDecoration(
                  labelText: 'Category (e.g., Food, Taxi)',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter a category' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteCtrl,
                decoration: const InputDecoration(labelText: 'Note (optional)'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text('Date: ${DateFormat.yMMMd().format(_date)}'),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text('Pick date'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _submit,
                child: Text(_isEditMode ? 'Update' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
