import 'package:flutter/material.dart';

class EmptyChart extends StatelessWidget {
  const EmptyChart({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 180,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(message, style: theme.textTheme.bodyMedium),
    );
  }
}