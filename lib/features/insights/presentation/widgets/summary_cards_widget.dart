import 'package:fin_track/app/extension/context_extension.dart';
import 'package:flutter/material.dart';

import '../../../transactions/presentation/formatters/formatters.dart';
import '../../data/model/insights_model.dart';
import 'stat_card.dart';

class SummaryCards extends StatelessWidget {
  const SummaryCards({super.key, required this.summary});

  final MonthlySummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        StatCard(
          title: context.loc.income,
          value: formatAED(summary.income),
          color: cs.primaryContainer,
          textColor: cs.onPrimaryContainer,
        ),
        StatCard(
          title: context.loc.expense,
          value: formatAED(summary.expense),
          color: cs.surfaceContainerHighest,
          textColor: cs.onSurface,
        ),
        StatCard(
          title: context.loc.net,
          value: formatAED(summary.net),
          color: summary.net >= 0
              ? cs.secondaryContainer
              : theme.colorScheme.errorContainer,
          textColor: summary.net >= 0
              ? cs.onSecondaryContainer
              : theme.colorScheme.onErrorContainer,
        ),
      ],
    );
  }
}
