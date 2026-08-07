import 'package:fin_track/core/extensions/spacing_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      padding: 16.padL + 12.padT + 16.padR + 24.padB,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 4.h, width: 40.w, margin: 12.padB, decoration: BoxDecoration(color: cs.outlineVariant, borderRadius: BorderRadius.circular(2.r))),
          Text('Export Data', style: Theme.of(context).textTheme.titleMedium),
          12.hBox,

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

          8.hBox,
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
              12.wBox,
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
