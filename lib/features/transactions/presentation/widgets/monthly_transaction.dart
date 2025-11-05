import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/format.dart';
import '../../domain/entities/transaction_entity.dart';
import '../controllers/transaction_providers.dart';
import 'empty_transactions_state.dart';
import 'month_daily_chart_exact.dart';
import 'month_summary_footer.dart';
import 'transaction_list_item.dart';

class TransactionsGroupedByMonth extends HookConsumerWidget {
  const TransactionsGroupedByMonth({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTxs = ref.watch(transactionsStreamProvider);

    return asyncTxs.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (items) {
        if (items.isEmpty) return const EmptyTransactionsState();

        final grouped = useMemoized(() {
          final Map<DateTime, List<TransactionEntity>> byMonth = {};
          for (final t in items) {
            final key = DateTime(t.date.year, t.date.month, 1);
            byMonth.putIfAbsent(key, () => []).add(t);
          }

          // Sort transactions within each month
          for (var txs in byMonth.values) {
            txs.sort((a, b) => b.date.compareTo(a.date));
          }

          // order months desc
          final monthKeys = byMonth.keys.toList()
            ..sort((a, b) => b.compareTo(a));
          return (byMonth: byMonth, monthKeys: monthKeys);
        }, [items]);

        // expanded state: default expand current month (if present)
        final expanded = useState<Set<int>>({
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            1,
          ).millisecondsSinceEpoch,
        });

        void toggleMonth(DateTime m) {
          final key = m.millisecondsSinceEpoch;
          expanded.value = {...expanded.value}.._toggle(key);
        }

        return CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            for (final m in grouped.monthKeys)
              ..._buildMonthSection(
                context: context,
                month: m,
                transactions: grouped.byMonth[m]!,
                isExpanded: expanded.value.contains(m.millisecondsSinceEpoch),
                onToggle: () => toggleMonth(m),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 96)),
          ],
        );
      },
    );
  }
}

extension on Set<int> {
  void _toggle(int key) {
    if (contains(key)) {
      remove(key);
    } else {
      add(key);
    }
  }
}

List<Widget> _buildMonthSection({
  required BuildContext context,
  required DateTime month,
  required List<TransactionEntity> transactions,
  required bool isExpanded,
  required VoidCallback onToggle,
}) {
  final total = transactions.fold<double>(0, (s, e) => s + e.amount);

  return [
    SliverPersistentHeader(
      pinned: true,
      delegate: _EnhancedMonthHeaderDelegate(
        month: month,
        total: total,
        isExpanded: isExpanded,
        onTap: onToggle,
        minExtent: 56,
        maxExtent: 64,
      ),
    ),

    // Animated expand/collapse content
    SliverToBoxAdapter(
      child: _AnimatedMonthBody(
        isExpanded: isExpanded,
        month: month,
        transactions: transactions,
      ),
    ),
  ];
}

class _EnhancedMonthHeaderDelegate extends SliverPersistentHeaderDelegate {
  _EnhancedMonthHeaderDelegate({
    required this.month,
    required this.total,
    required this.isExpanded,
    required this.onTap,
    required this.minExtent,
    required this.maxExtent,
  });

  final DateTime month;
  final double total;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  final double minExtent;
  @override
  final double maxExtent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    // 0.0 when fully expanded header, 1.0 when fully pinned/collapsed
    final pinT = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

    // Keep subtle elevation when pinned or overlapping
    final elevation = pinT > 0.05 || overlapsContent ? 2.0 : 0.0;

    // Slightly stronger overlay as it pins (no blur involved)
    final surfaceOpacity = lerpDouble(0.90, 0.96, pinT)!;

    return Material(
      color: Colors.transparent,
      elevation: elevation,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Solid base surface
          Container(color: Theme.of(context).scaffoldBackgroundColor),

          // Soft gradient tint (same design as before)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  cs.primary.withOpacity(0.06),
                  cs.secondary.withOpacity(0.05),
                ],
              ),
            ),
          ),

          // Opaque surface overlay that animates with pin (replacing blur layer)
          Container(
            color: Theme.of(
              context,
            ).scaffoldBackgroundColor.withOpacity(surfaceOpacity),
          ),

          // Content row
          InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              onTap();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Month + year
                  Text(
                    DateFormat('MMMM yyyy').format(month),
                    style: t.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Divider that becomes a bit more visible as it pins
                  Expanded(
                    child: Opacity(
                      opacity: lerpDouble(0.6, 1.0, pinT)!,
                      child: Divider(height: 1, color: cs.outlineVariant),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Total pill (unchanged)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.symmetric(
                      horizontal: lerpDouble(10, 12, pinT)!.toDouble(),
                      vertical: lerpDouble(6, 7, pinT)!.toDouble(),
                    ),
                    decoration: BoxDecoration(
                      color: (total < 0 ? Colors.red : Colors.green)
                          .withOpacity(0.12),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: (total < 0 ? Colors.red : Colors.green)
                            .withOpacity(0.35),
                      ),
                    ),
                    child: Text(
                      '${total < 0 ? '-' : '+'} ${fmtMoneyCompact(total.abs())}',
                      style: t.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontFeatures: const [FontFeature.tabularFigures()],
                        color: total < 0 ? Colors.red : Colors.green,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Chevron rotation (unchanged)
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    child: const Icon(Icons.expand_more),
                  ),
                ],
              ),
            ),
          ),

          // Always-visible hairline under the header
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(height: 0.5, color: cs.outlineVariant),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _EnhancedMonthHeaderDelegate old) {
    return old.month != month ||
        old.total != total ||
        old.isExpanded != isExpanded ||
        old.minExtent != minExtent ||
        old.maxExtent != maxExtent;
  }
}

class _AnimatedMonthBody extends StatelessWidget {
  const _AnimatedMonthBody({
    required this.isExpanded,
    required this.month,
    required this.transactions,
  });

  final bool isExpanded;
  final DateTime month;
  final List<TransactionEntity> transactions;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState: isExpanded
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 260),
      firstCurve: Curves.easeOutCubic,
      secondCurve: Curves.easeOutCubic,
      sizeCurve: Curves.easeOutCubic,
      firstChild: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          // NEW: Daily chart for the month
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: MonthDailyChartExact(
              month: month,
              transactions: transactions,
              onDayTap: (day) {
                // optional: filter/scroll your list to this day
              },
            ),
          ),

          const SizedBox(height: 12),
          for (final t in transactions) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TransactionListItem(t: t),
            ),
            const SizedBox(height: 10),
          ],
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
            child: MonthSummaryFooter(month: month),
          ),
        ],
      ),
      // Keep a zero-sized box when collapsed to avoid layout jumps
      secondChild: const SizedBox.shrink(),
    );
  }
}

/// Sticky month header that looks/behaves like a tappable ExpansionTile header.
// ignore: unused_element
class _MonthHeaderDelegate extends SliverPersistentHeaderDelegate {
  _MonthHeaderDelegate({
    required this.month,
    required this.onTap,
    required this.isExpanded,
    required this.minExtent,
    required this.maxExtent,
  });

  final DateTime month;
  final VoidCallback onTap;
  final bool isExpanded;

  @override
  final double minExtent;
  @override
  final double maxExtent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    final elevation = (overlapsContent || shrinkOffset > 0)
        ? 1.0
        : 0.0; // subtle shadow

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: elevation,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text(
                DateFormat('MMMM yyyy').format(month),
                style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 8),
              Expanded(child: Divider(height: 1, color: cs.outlineVariant)),
              const SizedBox(width: 8),
              RotationTransition(
                turns: AlwaysStoppedAnimation(isExpanded ? 0.5 : 0.0),
                child: const Icon(Icons.expand_more),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _MonthHeaderDelegate oldDelegate) {
    return oldDelegate.month != month ||
        oldDelegate.isExpanded != isExpanded ||
        oldDelegate.minExtent != minExtent ||
        oldDelegate.maxExtent != maxExtent;
  }
}
