import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../features/transactions/presentation/controllers/budget_provider.dart';

Future<void> editBudgetDialog(
  BuildContext context,
  WidgetRef ref,
  DateTime month,
  double? current,
) async {
  final ctrl = TextEditingController(
    text: current == null ? '' : current.toStringAsFixed(2),
  );
  final formKey = GlobalKey<FormState>();

  await showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Text('Set budget - ${DateFormat('MMM yyyy').format(month)}'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: ctrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Budget (AED)'),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Enter an amount';
              final d = double.tryParse(v);
              if (d == null || d <= 0) return 'Enter a positive amount';
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (!(formKey.currentState?.validate() ?? false)) return;
              final val = double.parse(ctrl.text);
              await ref
                  .read(budgetControllerProvider.notifier)
                  .setBudget(month, val);
              if (context.mounted) Navigator.of(ctx).pop();
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
