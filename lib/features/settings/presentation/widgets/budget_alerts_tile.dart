import 'package:fin_track/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/notifications/budget_alert_service.dart';

class BudgetAlertsTile extends ConsumerWidget {
  const BudgetAlertsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final svc = ref.watch(budgetAlertServiceProvider);
    return SwitchListTile(
      title: Text(context.loc.budgetAlertsTitle),
      value: svc.alertsEnabled,
      onChanged: (v) async {
        await svc.setAlertsEnabled(v);
        // ignore: unused_result
        ref.invalidate(budgetAlertServiceProvider);
      },
    );
  }
}