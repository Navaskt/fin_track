import 'package:fin_track/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
          const SizedBox(height: 12),
          SummaryCards(summary: data.summary),
          const SizedBox(height: 16),
          CategoryBreakdown(slices: data.byCategory),
          const SizedBox(height: 16),
          DailyTrend(daily: data.dailyExpense),
          const SizedBox(height: 16),
          TopCategories(categories: data.byCategory),
        ],
      ),
    );
  }
}
