import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/transaction_entity.dart';
import '../controllers/transaction_providers.dart';

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

  @override
  void dispose() {
    _amountCtrl.dispose();
    _categoryCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.id == null ? 'Add Transaction' : 'Edit Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _amountCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Amount (AED)'),
                validator: (v) {
                  final value = double.tryParse(v ?? '');
                  if (value == null || value <= 0) return 'Enter valid amount';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoryCtrl,
                decoration: const InputDecoration(labelText: 'Category (e.g., Food, Taxi)'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter category' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteCtrl,
                decoration: const InputDecoration(labelText: 'Note (optional)'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: Text('Date: ${_date.toLocal()}'.split('.').first)),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => _date = picked);
                    },
                    child: const Text('Pick date'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  final e = TransactionEntity(
                    id: widget.id ?? const Uuid().v4(),
                    amount: double.parse(_amountCtrl.text),
                    category: _categoryCtrl.text.trim(),
                    note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
                    date: _date,
                  );
                  await ref.read(transactionControllerProvider.notifier).addOrUpdate(e);
                  if (mounted) Navigator.of(context).pop();
                },
                child: Text(widget.id == null ? 'Save' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}