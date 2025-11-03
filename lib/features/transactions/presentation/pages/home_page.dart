import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../controllers/theme_provider.dart';
import '../controllers/transaction_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTxs = ref.watch(transactionsStreamProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface, // subtle surface color
      appBar: AppBar(
        title: const Text('FinTrack'),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
        actions: [
          PopupMenuButton(
            tooltip: 'Theme mode',
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'light', child: Text('Light')),
              PopupMenuItem(value: 'dark', child: Text('Dark')),
              PopupMenuItem(value: 'system', child: Text('System')),
            ],
            onSelected: (v) {
              final notifier = ref.read(themeModeProvider.notifier);
              if (v == 'light') notifier.state = ThemeMode.light;
              if (v == 'dark') notifier.state = ThemeMode.dark;
              if (v == 'system') notifier.state = ThemeMode.system;
            },
          ),
        ],
      ),
      body: SafeArea(
        child: asyncTxs.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (items) {
            if (items.isEmpty) {
              return const _EmptyState();
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final t = items[i];
                final isNegative = t.amount < 0;
                final amountStr = _formatCurrency(t.amount.abs());
                final amountColor = isNegative ? Colors.red : Colors.green;

                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => context.push('/edit/${t.id}'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest, // M3 friendly
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: cs.outlineVariant),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                          color: cs.shadow.withOpacity(0.06),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        _CategoryBadge(text: t.category),
                        const SizedBox(width: 12),

                        // Title & date
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Category • Amount (monospace digits)
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      t.category,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${isNegative ? '-' : '+'}$amountStr',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: amountColor,
                                          fontFeatures: const [
                                            FontFeature.tabularFigures(),
                                          ],
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _friendlyDate(t.date),
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: cs.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Delete
                        IconButton(
                          tooltip: 'Delete',
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => ref
                              .read(transactionControllerProvider.notifier)
                              .delete(t.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final initial = text.isEmpty ? '?' : text.characters.first.toUpperCase();
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        initial,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: cs.onPrimaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 56,
              color: cs.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'No transactions yet',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Tap the Add button to record your first expense or income.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

// --------- Formatting helpers (UI only) ---------

String _friendlyDate(DateTime d) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final date = DateTime(d.year, d.month, d.day);
  if (date == today) return 'Today';
  if (date == today.subtract(const Duration(days: 1))) return 'Yesterday';
  return DateFormat('dd MMM yyyy').format(d);
}

String _formatCurrency(num v) {
  // Change currency name/symbol if you prefer
  final f = NumberFormat.currency(name: 'AED', symbol: 'AED ');
  return f.format(v);
}
