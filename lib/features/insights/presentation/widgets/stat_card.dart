import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.textColor,
  });

  final String title;
  final String value;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: 220,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textTheme.labelLarge?.copyWith(color: textColor)),
          const SizedBox(height: 6),
          Text(value, style: textTheme.displayLarge?.copyWith(color: textColor, fontSize: 22)),
        ],
      ),
    );
  }
}