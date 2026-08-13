import 'package:fin_track/app/extension/context_extension.dart';
import 'package:fin_track/core/extensions/spacing_extension.dart';
import 'package:flutter/material.dart';

import 'daily_line_chart.dart';

class DailyTrend extends StatelessWidget {
  const DailyTrend({super.key, required this.daily});

  final List<MapEntry<DateTime, double>> daily;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.loc.dailyExpenseTrend, style: theme.textTheme.titleLarge),
        8.hBox,
        DailyLineChart(daily: daily),
      ],
    );
  }
}
