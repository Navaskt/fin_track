import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/transactions/presentation/controllers/budget_status_provider.dart';
import 'notification_service.dart';

class BudgetAlertService {
  BudgetAlertService(this._settingsBox);
  final Box<String> _settingsBox;

  static const _thresholds = [1.0, 0.8]; // check highest first

  bool get alertsEnabled =>
      _settingsBox.get('budget_alerts_enabled') != 'false';

  Future<void> setAlertsEnabled(bool enabled) async {
    await _settingsBox.put('budget_alerts_enabled', enabled.toString());
  }

  String _key(DateTime monthKey, double threshold) =>
      'budget_alert_${monthKey.year}-${monthKey.month}_${(threshold * 100).round()}';

  Future<void> checkAndNotify(BudgetStatus status) async {
    if (!alertsEnabled) return;
    final ratio = status.ratio;
    if (ratio == null) return;

    for (final threshold in _thresholds) {
      if (ratio < threshold) continue;

      final key = _key(status.monthKey, threshold);
      final alreadyNotified = _settingsBox.get(key) == 'true';
      if (alreadyNotified) return; // this or a higher tier was already shown

      await _settingsBox.put(key, 'true');
      final isOver = threshold >= 1.0;
      await NotificationService.showBudgetAlert(
        title: isOver ? 'Budget exceeded' : 'Budget alert',
        body: isOver
            ? "You've spent ${(ratio * 100).toStringAsFixed(0)}% of this month's budget."
            : "You've used ${(ratio * 100).toStringAsFixed(0)}% of this month's budget.",
      );
      return;
    }
  }
}

final budgetAlertServiceProvider = Provider<BudgetAlertService>((ref) {
  final box = Hive.box<String>('app_settings');
  return BudgetAlertService(box);
});
