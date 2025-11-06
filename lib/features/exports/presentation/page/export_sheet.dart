import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/export_controller.dart';

class ExportSheet extends ConsumerStatefulWidget {
  const ExportSheet({super.key});

  @override
  ConsumerState<ExportSheet> createState() => _ExportSheetState();
}

class _ExportSheetState extends ConsumerState<ExportSheet> {
  DateTimeRange? _range;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    _range = DateTimeRange(start: startOfMonth, end: now);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final rangeText = (_range == null)
        ? 'Select range'
        : '${_fmt(_range!.start)} - ${_fmt(_range!.end)}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 4, width: 40, margin: const EdgeInsets.only(bottom: 12), decoration: BoxDecoration(color: cs.outlineVariant, borderRadius: BorderRadius.circular(2))),
          Text('Export Data', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),

          ListTile(
            leading: const Icon(Icons.date_range),
            title: const Text('Date range'),
            subtitle: Text(rangeText),
            onTap: () async {
              final now = DateTime.now();
              final lastYear = DateTime(now.year - 1, now.month, now.day);
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime(now.year + 1, 12, 31),
                initialDateRange: _range ?? DateTimeRange(start: lastYear, end: now),
              );
              if (picked != null) {
                setState(() => _range = picked);
              }
            },
          ),

          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.table_view),
                  label: const Text('Export CSV'),
                  onPressed: _range == null ? null : () async {
                    final c = ref.read(exportControllerProvider);
                    await c.exportCsvAndShare(_range!);
                    if (mounted) Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Export PDF'),
                  onPressed: _range == null ? null : () async {
                    final c = ref.read(exportControllerProvider);
                    await c.exportPdfAndShare(_range!);
                    if (mounted) Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
}
