// lib/features/transactions/presentation/widgets/month_daily_chart_exact.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/transaction_entity.dart';

class MonthDailyChartExactWithBudget extends StatefulWidget {
  const MonthDailyChartExactWithBudget({
    super.key,
    required this.month,
    required this.transactions,
    required this.monthlyBudgetAED, // NEW
    this.onDayTap,
  });

  final DateTime month;
  final List<TransactionEntity> transactions;
  final double monthlyBudgetAED; // NEW
  final void Function(DateTime day)? onDayTap;

  @override
  State<MonthDailyChartExactWithBudget> createState() => _MonthDailyChartExactWithBudgetState();
}

class _MonthDailyChartExactWithBudgetState extends State<MonthDailyChartExactWithBudget> {
  int? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final lastDay = DateTime(widget.month.year, widget.month.month + 1, 0).day;

    // Daily totals
    final incomes = List<double>.filled(lastDay, 0);
    final expenses = List<double>.filled(lastDay, 0);
    for (final tx in widget.transactions) {
      if (tx.date.year == widget.month.year && tx.date.month == widget.month.month) {
        final i = tx.date.day - 1;
        if (tx.amount >= 0) {
          incomes[i] += tx.amount;
        } else {
          expenses[i] += tx.amount.abs();
        }
      }
    }

    // CUMULATIVE expense = the line we draw "against budget"
    final cumExpense = <double>[];
    double run = 0;
    for (final v in expenses) {
      run += v;
      cumExpense.add(run);
    }

    // Scale so both budget line and data fit nicely
    final maxData = cumExpense.isEmpty ? 0 : cumExpense.reduce((a, b) => a > b ? a : b);
    final yMaxCandidate = [maxData, widget.monthlyBudgetAED].reduce((a, b) => a > b ? a : b);
    final yMax = (yMaxCandidate == 0 ? 100.0 : yMaxCandidate * 1.25);

    String kMoney(double v) {
      if (v >= 1000000) return 'AED ${(v / 1000000).toStringAsFixed(1)}M';
      if (v >= 1000) return 'AED ${(v / 1000).toStringAsFixed(1)}K';
      return 'AED ${v.toStringAsFixed(0)}';
    }

    String xLabel(double value) {
      final d = value.toInt();
      if (d < 1 || d > lastDay) return '';
      return (d == 1 || d == lastDay || d % 5 == 0) ? '$d' : '';
    }

    // Chart spots (cumulative expense)
    final spots = List<FlSpot>.generate(
      lastDay,
      (i) => FlSpot((i + 1).toDouble(), cumExpense[i]),
    );

    // Optional current-day guide
    final now = DateTime.now();
    final isCurrentMonth = now.year == widget.month.year && now.month == widget.month.month;
    final todayX = isCurrentMonth ? now.day.toDouble() : null;

    // First day that crosses budget (for subtle emphasis after crossing)
    final crossIndex = cumExpense.indexWhere((v) => v >= widget.monthlyBudgetAED);

    // Split into two segments so the over-budget part can look slightly stronger
    final beforeSpots = <FlSpot>[];
    final afterSpots = <FlSpot>[];
    if (crossIndex == -1) {
      beforeSpots.addAll(spots);
    } else {
      for (var i = 0; i < spots.length; i++) {
        if (i <= crossIndex) {
          beforeSpots.add(spots[i]);
        } else {
          afterSpots.add(spots[i]);
        }
      }
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 16, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.6)),
      ),
      height: 220,
      child: LineChart(
        LineChartData(
          minX: 1,
          maxX: lastDay.toDouble(),
          minY: 0,
          maxY: yMax,
          backgroundColor: Colors.transparent,

          // Guides: dashed vertical (touch), dashed horizontal (budget), faint "today"
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: widget.monthlyBudgetAED,
                color: Colors.white.withOpacity(0.35),
                strokeWidth: 1,
                dashArray: [6, 6],
              ),
            ],
            verticalLines: [
              if (_selectedDay != null)
                VerticalLine(
                  x: _selectedDay!.toDouble(),
                  color: Colors.white.withOpacity(0.35),
                  strokeWidth: 1,
                  dashArray: [4, 6],
                ),
              if (todayX != null)
                VerticalLine(
                  x: todayX,
                  color: Colors.white.withOpacity(0.2),
                  strokeWidth: 1,
                  dashArray: [2, 8],
                ),
            ],
          ),

          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (yMax / 4).clamp(1, double.infinity),
            getDrawingHorizontalLine: (v) => FlLine(
              color: Colors.white.withOpacity(0.08),
              strokeWidth: 1,
            ),
          ),

          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 48,
                getTitlesWidget: (v, _) =>
                    Text(kMoney(v), style: const TextStyle(fontSize: 10, color: Colors.white70)),
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, _) =>
                    Text(xLabel(v), style: const TextStyle(fontSize: 10, color: Colors.white70)),
              ),
            ),
          ),

          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),

          // Red line + soft fill. After crossing budget, slightly stronger red.
          lineBarsData: [
            // Before crossing
            if (beforeSpots.isNotEmpty)
              LineChartBarData(
                spots: beforeSpots,
                isCurved: true,
                barWidth: 2.5,
                color: Colors.red,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (s, __, ___, ____) => FlDotCirclePainter(
                    radius: 2,
                    color: Colors.red,
                    strokeColor: Colors.white,
                    strokeWidth: 0.8,
                  ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [Colors.red.withOpacity(0.28), Colors.red.withOpacity(0.02)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            // After crossing (emphasize a bit)
            if (afterSpots.isNotEmpty)
              LineChartBarData(
                spots: afterSpots,
                isCurved: true,
                barWidth: 2.5,
                color: const Color(0xFFFF3B30), // slightly brighter red
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (s, __, ___, ____) => FlDotCirclePainter(
                    radius: 2,
                    color: const Color(0xFFFF3B30),
                    strokeColor: Colors.white,
                    strokeWidth: 0.8,
                  ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [const Color(0xFFFF3B30).withOpacity(0.30), Colors.red.withOpacity(0.04)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
          ],

          // Touch -> multiline black tooltip with budget math
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchSpotThreshold: 24,
            touchCallback: (evt, resp) {
              if (resp?.lineBarSpots?.isNotEmpty == true) {
                final d = resp!.lineBarSpots!.first.x.toInt();
                setState(() => _selectedDay = d);
                widget.onDayTap?.call(DateTime(widget.month.year, widget.month.month, d));
              }
            },
            touchTooltipData: LineTouchTooltipData(
              tooltipRoundedRadius: 8,
              tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              tooltipMargin: 12,
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipColor: (_) => const Color(0xFF111111).withOpacity(0.95),
              getTooltipItems: (items) {
                if (items.isEmpty) return [];
                final d = items.first.x.toInt();
                final spent = cumExpense[d - 1];
                final budget = widget.monthlyBudgetAED;
                final delta = budget - spent;
                final remaining = delta >= 0 ? kMoney(delta) : '-';
                final over = delta < 0 ? kMoney(delta.abs()) : '-';

                final dateStr = DateFormat('MMM d, yyyy')
                    .format(DateTime(widget.month.year, widget.month.month, d));

                return [
                  LineTooltipItem(
                    '$dateStr\n'
                    'Spent:   ${kMoney(spent)}\n'
                    'Budget:  ${kMoney(budget)}\n'
                    'Remain:  $remaining   Over: $over',
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, height: 1.25),
                  ),
                ];
              },
            ),
          ),
        ),
      ),
    );
  }
}
