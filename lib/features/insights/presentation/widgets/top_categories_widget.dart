import 'package:fin_track/app/extension/context_extension.dart';
import 'package:flutter/material.dart';

import '../../../transactions/presentation/formatters/formatters.dart';
import '../../data/model/insights_model.dart';

class TopCategories extends StatelessWidget {
  const TopCategories({super.key, required this.categories});

  final List<CategorySlice> categories;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.loc.topCategories, style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        for (final c in categories.take(5))
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(c.category),
            trailing: Text('${(c.ratio * 100).toStringAsFixed(1)}%  •  ${formatAED(c.amount)}'),
          ),
      ],
    );
  }
}