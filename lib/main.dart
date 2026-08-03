import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/router.dart';
import 'app/theme/app_theme.dart';
import 'core/notifications/budget_alert_service.dart';
import 'core/notifications/notification_service.dart';
import 'features/transactions/data/models/transaction_model.dart';
import 'features/transactions/data/models/transaction_model_adaptor.dart';
import 'features/transactions/presentation/controllers/budget_status_provider.dart';
import 'features/transactions/presentation/controllers/locale_provider.dart';
import 'features/transactions/presentation/controllers/theme_provider.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionModelAdapter());
  await Hive.openBox<TransactionModel>('transactions');
  await Hive.openBox<double>('monthly_budgets');
  await Hive.openBox<String>('app_settings');

  await NotificationService.init();
  await NotificationService.requestPermissions();

  runApp(const ProviderScope(child: FinTrackApp()));
}

class FinTrackApp extends ConsumerWidget {
  const FinTrackApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final mode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    ref.listen<BudgetStatus>(budgetStatusProvider, (previous, next) {
      ref.read(budgetAlertServiceProvider).checkAndNotify(next);
    });

    return MaterialApp.router(
      title: 'FinTrack',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: mode,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}
