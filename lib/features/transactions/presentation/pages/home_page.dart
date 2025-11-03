import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/theme_provider.dart';
import '../widgets/monthly_transaction.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface, // subtle surface color
      appBar: AppBar(
        title: const Text('FinTrack'),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
        actions: [
          PopupMenuButton(
            tooltip: 'Theme mode',
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'light', child: Text('Light')),
              PopupMenuItem(value: 'dark', child: Text('Dark')),
              PopupMenuItem(value: 'system', child: Text('System')),
            ],
            onSelected: (v) {
              final notifier = ref.read(themeModeProvider.notifier);
              if (v == 'light') notifier.state = ThemeMode.light;
              if (v == 'dark') notifier.state = ThemeMode.dark;
              if (v == 'system') notifier.state = ThemeMode.system;
            },
          ),
        ],
      ),
      body: TransactionsGroupedByMonth(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
    );
  }
}
