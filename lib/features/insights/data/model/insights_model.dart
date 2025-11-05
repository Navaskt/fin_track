class MonthlySummary {
  final DateTime month; // normalized to first day
  final double income;
  final double expense; // positive number
  double get net => income - expense;

  const MonthlySummary({
    required this.month,
    required this.income,
    required this.expense,
  });
}

class CategorySlice {
  final String category; // your existing category string
  final double amount;   // positive number for expense
  final double ratio;    // 0..1 within the month

  const CategorySlice({required this.category, required this.amount, required this.ratio});
}

class InsightsData {
  final MonthlySummary summary;
  final List<CategorySlice> byCategory;
  final List<MapEntry<DateTime,double>> dailyExpense; // for trend
  const InsightsData({
    required this.summary,
    required this.byCategory,
    required this.dailyExpense,
  });
}
