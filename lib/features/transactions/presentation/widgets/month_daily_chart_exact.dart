// lib/features/transactions/presentation/widgets/month_daily_chart_exact.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/transaction_entity.dart';

class MonthDailyChartExact extends StatefulWidget {
  const MonthDailyChartExact({
    super.key,
    required this.month,
    required this.transactions,
    this.onDayTap,
  });

  final DateTime month;
  final List<TransactionEntity> transactions;
  final void Function(DateTime day)? onDayTap;

  @override
  State<MonthDailyChartExact> createState() => _MonthDailyChartExactState();
}

class _MonthDailyChartExactState extends State<MonthDailyChartExact> {
  int? _selectedDay; // 1..lastDay

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final lastDay = DateTime(widget.month.year, widget.month.month + 1, 0).day;

    // Buckets
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

    final red = Colors.red;
    final maxY = [
      ...expenses,
      ...incomes, // used for tooltip only, still helpful for scaling
    ].fold<double>(0, (m, v) => v > m ? v : m);
    final yMax = (maxY == 0 ? 100.0 : maxY * 1.25);

    String kMoney(double v) {
      // Show “$4.0K / $1.2M”-style. Replace symbol if you prefer formatAED.
      if (v >= 1000000) return 'AED ${(v / 1000000).toStringAsFixed(1)}M';
      if (v >= 1000) return 'AED ${(v / 1000).toStringAsFixed(1)}K';
      return 'AED ${v.toStringAsFixed(0)}';
    }

    String xLabel(double value) {
      final d = value.toInt();
      if (d < 1 || d > lastDay) return '';
      return (d == 1 || d == lastDay || d % 5 == 0) ? '$d' : '';
    }

    // Data -> red line
    final spots = List<FlSpot>.generate(
      lastDay,
      (i) => FlSpot((i + 1).toDouble(), expenses[i]),
    );

    // Optional "today" guide
    final now = DateTime.now();
    final isCurrentMonth = now.year == widget.month.year && now.month == widget.month.month;
    final todayX = isCurrentMonth ? now.day.toDouble() : null;

    // Touch guide (dashed)
    final guideX = _selectedDay?.toDouble();

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 16, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF171717), // deep surface to match screenshot
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

          // Dashed guides: selected & today
          extraLinesData: ExtraLinesData(
            verticalLines: [
              if (guideX != null)
                VerticalLine(
                  x: guideX,
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
                reservedSize: 46,
                getTitlesWidget: (v, _) => Text(
                  kMoney(v),
                  style: const TextStyle(fontSize: 10, color: Colors.white70),
                ),
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, _) => Text(
                  xLabel(v),
                  style: const TextStyle(fontSize: 10, color: Colors.white70),
                ),
              ),
            ),
          ),

          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),

          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              barWidth: 2.5,
              color: red,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (s, __, ___, ____) => FlDotCirclePainter(
                  radius: s.y > 0 ? 2 : 0,
                  color: red,
                  strokeColor: Colors.white,
                  strokeWidth: 0.8,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [red.withOpacity(0.28), red.withOpacity(0.02)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],

          // Touch -> black rounded tooltip with multiline
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
              tooltipMargin: 12, // space from touch point, similar to screenshot
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipColor: (_) => const Color(0xFF111111).withOpacity(0.95),
              getTooltipItems: (items) {
                if (items.isEmpty) return [];
                final d = items.first.x.toInt();
                final date = DateTime(widget.month.year, widget.month.month, d);
                final dateStr = DateFormat('MMM d, yyyy').format(date);
                final exp = expenses[d - 1];
                final inc = incomes[d - 1];

                // Multiline content to mimic your screenshot
                return [
                  LineTooltipItem(
                    '$dateStr\n'
                    'Expense: ${kMoney(exp)}\n'
                    'Income:  ${kMoney(inc)}',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
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
