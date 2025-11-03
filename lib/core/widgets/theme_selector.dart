import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/transactions/presentation/controllers/theme_provider.dart';

class ThemeSelector extends ConsumerWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<ThemeMode>(
      tooltip: 'Change theme',
      icon: const Icon(Icons.brightness_6),
      onSelected: (theme) {
        ref.read(themeModeProvider.notifier).state = theme;
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem(value: ThemeMode.light, child: Text('Light')),
          const PopupMenuItem(value: ThemeMode.dark, child: Text('Dark')),
          const PopupMenuItem(value: ThemeMode.system, child: Text('System')),
        ];
      },
    );
  }
}
