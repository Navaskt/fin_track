import 'package:fin_track/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../controllers/insights_provider.dart';

class MonthSelector extends ConsumerWidget {
  const MonthSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final month = ref.watch(selectedMonthProvider);

    return Row(
      children: [
        Text(DateFormat.yMMM().format(month), style: theme.textTheme.titleLarge),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => _shiftMonth(ref, -1),
          icon: const Icon(Icons.chevron_left),
          tooltip: context.loc.prevMonth,
        ),
        IconButton(
          onPressed: () => _shiftMonth(ref, 1),
          icon: const Icon(Icons.chevron_right),
          tooltip: context.loc.nextMonth,
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            final now = DateTime.now();
            ref.read(selectedMonthProvider.notifier).state = DateTime(now.year, now.month);
          },
          child: Text(context.loc.monthSelectorThisMonth),
        ),
      ],
    );
  }

  void _shiftMonth(WidgetRef ref, int step) {
    final currentMonth = ref.read(selectedMonthProvider);
    ref.read(selectedMonthProvider.notifier).state = DateTime(currentMonth.year, currentMonth.month + step);
  }
}