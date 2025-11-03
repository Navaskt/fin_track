import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/router.dart';
import 'app/theme/app_theme.dart';
import 'features/transactions/data/models/transaction_model.dart';
import 'features/transactions/data/models/transaction_model_adaptor.dart';


Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();
await Hive.initFlutter();
Hive.registerAdapter(TransactionModelAdapter());
await Hive.openBox<TransactionModel>('transactions');


runApp(const ProviderScope(child: FinTrackApp()));
}


class FinTrackApp extends ConsumerWidget {
const FinTrackApp({super.key});


@override
Widget build(BuildContext context, WidgetRef ref) {
final router = ref.watch(appRouterProvider);
final theme = buildAppTheme();


return MaterialApp.router(
debugShowCheckedModeBanner: false,
routerConfig: router,
theme: theme.light,
darkTheme: theme.dark,
themeMode: ThemeMode.system,
);
}
}