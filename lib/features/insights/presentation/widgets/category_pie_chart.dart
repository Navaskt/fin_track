import 'package:fin_track/app/extension/context_extension.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../data/model/insights_model.dart';
import 'empty_chart.dart';

class CategoryPieChart extends StatelessWidget {
  const CategoryPieChart({super.key, required this.slices});
  final List<CategorySlice> slices;

  @override
  Widget build(BuildContext context) {
    if (slices.isEmpty) {
      return EmptyChart(message: context.loc.noExpenses);
    }

    final textTheme = Theme.of(context).textTheme;
    final sections = [
      for (final s in slices)
        PieChartSectionData(
          value: s.amount,
          title: '${(s.ratio * 100).toStringAsFixed(0)}%',
          radius: 70,
          titleStyle: textTheme.labelLarge,
        ),
    ];

    return SizedBox(
      height: 220,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: PieChart(PieChartData(
            sections: sections,
            sectionsSpace: 2,
            centerSpaceRadius: 36,
          )),
        ),
      ),
    );
  }
}