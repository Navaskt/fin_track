import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../app/extension/context_extension.dart';
import '../../../../core/extensions/spacing_extension.dart';
import '../controllers/insights_provider.dart';
import '../widgets/category_breakdown_widget.dart';
import '../widgets/daily_trend_widget.dart';
import '../widgets/month_selector_widget.dart';
import '../widgets/summary_cards_widget.dart';
import '../widgets/top_categories_widget.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(insightsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.loc.insightsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const MonthSelector(),
          12.hBox,
          SummaryCards(summary: data.summary),
          16.hBox,
          CategoryBreakdown(slices: data.byCategory),
          16.hBox,
          DailyTrend(daily: data.dailyExpense),
          16.hBox,
          TopCategories(categories: data.byCategory),
        ],
      ),
    );
  }
}
