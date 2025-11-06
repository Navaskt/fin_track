import 'package:fin_track/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/transaction_entity.dart';
import '../controllers/transaction_providers.dart';
import '../formatters/formatters.dart';
import 'category_badge.dart';

class TransactionListItem extends ConsumerWidget {
  const TransactionListItem({super.key, required this.t});
  final TransactionEntity t;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final isNegative = t.amount < 0;
    final amount = fmtMoneyCompact(t.amount.abs());
    final hasNote = (t.note?.trim().isNotEmpty ?? false);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.push('/edit/${t.id}'),
      onLongPress: hasNote ? () => _copyNote(context, t.note!.trim()) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CategoryBadge(text: t.category),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    friendlyDate(t.date, context),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  if (hasNote) ...[
                    const SizedBox(height: 4),
                    InkWell(
                      onTap: () => _showNoteSheet(context, ref, t),
                      borderRadius: BorderRadius.circular(8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(Icons.sticky_note_2_outlined, size: 16),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              t.note!.trim(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${isNegative ? '-' : '+'}$amount',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isNegative ? Colors.red : Colors.green,
                fontFeatures: const [FontFeature.tabularFigures()],
                fontWeight: FontWeight.w700,
              ),
            ),
            IconButton(
              tooltip: context.loc.delete,
              splashRadius: 20,
              icon: Icon(Icons.delete_outline, color: cs.secondary),
              onPressed: () =>
                  ref.read(transactionControllerProvider.notifier).delete(t.id),
            ),
          ],
        ),
      ),
    );
  }

  void _copyNote(BuildContext context, String note) {
    Clipboard.setData(ClipboardData(text: note));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.loc.copiedToClipboard)));
  }
}

// NOTE: _showNoteSheet and _editNoteDialog are tightly coupled.
// You could move them to a separate `transaction_dialogs.dart` helper file,
// or extract their content into dedicated widgets. For now, they are kept here
// for simplicity but should be moved out of the main UI file.

Future<void> _showNoteSheet(
  BuildContext context,
  WidgetRef ref,
  TransactionEntity t,
) async {
  final cs = Theme.of(context).colorScheme;

  await showModalBottomSheet(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    backgroundColor: cs.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 8,
          bottom: 16 + MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ctx.loc.note, // localize "Note"
              style: Theme.of(
                ctx,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            SelectableText(
              (t.note ?? '').trim(),
              style: Theme.of(ctx).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () async {
                    Navigator.of(ctx).pop();
                    await _editNoteDialog(context, ref, t);
                  },
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(ctx.loc.edit),
                ),
                const SizedBox(width: 8),
                if ((t.note?.isNotEmpty ?? false))
                  TextButton.icon(
                    onPressed: () async {
                      // Clear the note
                      await ref
                          .read(transactionControllerProvider.notifier)
                          .updateNote(t.id, null);
                      Navigator.of(ctx).pop();
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: Text(ctx.loc.clear),
                  ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(ctx.loc.close),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Future<void> _editNoteDialog(
  BuildContext context,
  WidgetRef ref,
  TransactionEntity t,
) async {
  final controller = TextEditingController(text: t.note ?? '');
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Text(ctx.loc.editNote),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 5,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(hintText: ctx.loc.typeYourNote),
          onSubmitted: (_) => Navigator.of(ctx).pop(true),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(ctx.loc.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(ctx.loc.save),
          ),
        ],
      );
    },
  );

  if (result == true) {
    final newText = controller.text.trim();
    await ref
        .read(transactionControllerProvider.notifier)
        .updateNote(t.id, newText.isEmpty ? null : newText);
  }
}
