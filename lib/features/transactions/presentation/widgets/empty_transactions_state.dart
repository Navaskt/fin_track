import 'package:fin_track/app/extension/context_extension.dart';
import 'package:fin_track/core/extensions/spacing_extension.dart';
import 'package:flutter/material.dart';

class EmptyTransactionsState extends StatelessWidget {
  const EmptyTransactionsState({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: 24.padH,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 56,
              color: cs.primary,
            ),
            12.hBox,
            Text(
              context.loc.noTransactions,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              6.hBox,
            Text(
              context.loc.addFirstTransaction,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
