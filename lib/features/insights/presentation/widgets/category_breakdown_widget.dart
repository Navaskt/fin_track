import 'package:fin_track/app/extension/context_extension.dart';
import 'package:flutter/material.dart';

import '../../data/model/insights_model.dart';
import 'category_pie_chart.dart';

class CategoryBreakdown extends StatelessWidget {
  const CategoryBreakdown({super.key, required this.slices});

  final List<CategorySlice> slices;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.loc.byCategory, style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        CategoryPieChart(slices: slices),
      ],
    );
  }
}
