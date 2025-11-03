import 'package:fin_track/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/language_selector.dart';
import '../../../../core/widgets/theme_selector.dart';
import '../widgets/monthly_transaction.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(context.loc.appTitle),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
        actions: [const LanguageSelector(), const ThemeSelector()],
      ),
      body: const TransactionsGroupedByMonth(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add'),
        icon: const Icon(Icons.add),
        label: Text(context.loc.addButton),
      ),
    );
  }
}
