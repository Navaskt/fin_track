import 'package:fin_track/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../exports/presentation/page/export_sheet.dart';

class ExportTile extends ConsumerWidget {
  const ExportTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(Icons.file_upload_outlined, color: cs.secondary),
      title: Text(context.loc.exportData),
      subtitle: Text('${context.loc.exportCsv} · ${context.loc.exportPdf}'),
      onTap: () => showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => const ExportSheet(),
      ),
    );
  }
}
