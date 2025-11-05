import 'package:fin_track/app/extension/context_extension.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'empty_chart.dart';

class DailyLineChart extends StatelessWidget {
  const DailyLineChart({super.key, required this.daily});
  final List<MapEntry<DateTime, double>> daily;

  @override
  Widget build(BuildContext context) {
    if (daily.isEmpty) return EmptyChart(message: context.loc.noData);

    final spots = [
      for (var i = 0; i < daily.length; i++) FlSpot(i.toDouble(), daily[i].value),
    ];

    return SizedBox(
      height: 220,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: LineChart(LineChartData(
            minY: 0,
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true, interval: (daily.length / 4).clamp(1.0, 7.0).toDouble())),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: const FlGridData(show: true),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(show: true, applyCutOffY: true),
              ),
            ],
          )),
        ),
      ),
    );
  }
}