import 'package:fin_track/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_utils.dart';
import '../../../../core/utils/format.dart';
import '../../domain/entities/transaction_entity.dart';
import '../controllers/budget_provider.dart';
import '../controllers/monthly_expense_provider.dart';
import '../controllers/transaction_providers.dart';

class TransactionsGroupedByMonth extends HookConsumerWidget {
  const TransactionsGroupedByMonth({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTxs = ref.watch(transactionsStreamProvider);

    return asyncTxs.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (items) {
        if (items.isEmpty) return const _EmptyState();

        final sections = useMemoized(() {
          // 1) sort latest first
          final sorted = [...items]..sort((a, b) => b.date.compareTo(a.date));

          // 2) group by month
          final Map<DateTime, List<TransactionEntity>> byMonth = {};
          for (final t in sorted) {
            final key = DateTime(t.date.year, t.date.month, 1);
            byMonth.putIfAbsent(key, () => []).add(t);
          }

          // 3) build a flat list with headers + footers
          final monthKeys = byMonth.keys.toList()
            ..sort((a, b) => b.compareTo(a));
          final sectionItems = <_SectionItem>[];

          for (final mk in monthKeys) {
            final list = byMonth[mk]!;
            final total = list.fold<double>(0, (s, e) => s + e.amount);

            sectionItems.add(_SectionItem.header(mk));
            sectionItems.addAll(list.map((t) => _SectionItem.item(t)));
            sectionItems.add(_SectionItem.footer(mk, total));
          }
          return sectionItems;
        }, [items]);

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
          itemCount: sections.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final s = sections[i];
            switch (s.type) {
              case _SectionType.header:
                return _MonthHeader(date: s.month!);
              case _SectionType.item:
                return _TxTile(t: s.tx!);
              case _SectionType.footer:
                return _MonthFooter(month: s.month!, total: s.total!);
            }
          },
        );
      },
    );
  }
}

// --- Section model ---

enum _SectionType { header, item, footer }

class _SectionItem {
  _SectionItem._(this.type, {this.month, this.tx, this.total});
  final _SectionType type;
  final DateTime? month;
  final TransactionEntity? tx;
  final double? total;

  factory _SectionItem.header(DateTime m) =>
      _SectionItem._(_SectionType.header, month: m);

  factory _SectionItem.item(TransactionEntity t) =>
      _SectionItem._(_SectionType.item, tx: t);

  factory _SectionItem.footer(DateTime m, double total) =>
      _SectionItem._(_SectionType.footer, month: m, total: total);
}

// --- UI pieces ---

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 2),
      child: Row(
        children: [
          Text(
            DateFormat('MMMM yyyy').format(date),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 8),
          Expanded(child: Divider(height: 1, color: cs.outlineVariant)),
        ],
      ),
    );
  }
}

class _TxTile extends ConsumerWidget {
  const _TxTile({required this.t});
  final TransactionEntity t;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final isNegative = t.amount < 0;
    final amount = formatAED(t.amount.abs());

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.push('/edit/${t.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 2,
          ),
          leading: _CategoryBadge(text: t.category),
          title: Text(
            t.category,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            friendlyDate(t.date),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
          trailing: SizedBox(
            width: 200,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => ref
                      .read(transactionControllerProvider.notifier)
                      .delete(t.id),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MonthFooter extends ConsumerWidget {
  const _MonthFooter({required this.month, required this.total});

  final DateTime month;
  final double total; // net (income - expense)

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final budgetAsync = ref.watch(budgetForMonthProvider(month));
    final expensesAsync = ref.watch(monthExpenseOnlyProvider(month));
    final totalTextColor = total < 0 ? Colors.red : Colors.green;

    if (budgetAsync.isLoading || expensesAsync.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (budgetAsync.hasError || expensesAsync.hasError) {
      final error = budgetAsync.error ?? expensesAsync.error;
      return Text('Error: $error', style: TextStyle(color: cs.error));
    }

    final budget = budgetAsync.value;
    final expenseOnly = expensesAsync.value!;
    final remaining = budget == null ? null : (budget - expenseOnly);
    final hasBudget = budget != null;

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          initiallyExpanded: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MMM yyyy').format(month),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                '${total < 0 ? '-' : '+'} ${formatAED(total.abs())}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: totalTextColor,
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              hasBudget ? context.loc.budgetSet : context.loc.noBudgetSet,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${context.loc.budget}:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  budget == null ? '-' : formatAED(budget),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${context.loc.spent}:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  formatAED(expenseOnly),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${context.loc.remaining}:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  remaining == null ? '-' : formatAED(remaining),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: remaining == null
                        ? cs.onSurfaceVariant
                        : (remaining >= 0 ? Colors.green : Colors.red),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                tooltip: budget == null
                    ? context.loc.setBudget
                    : context.loc.editBudget,
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => editBudgetDialog(context, ref, month, budget),
              ),
            ),
          ],
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
              context.loc.noTransactions,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              context.loc.addFirstTransaction,
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

// --- helpers ---
