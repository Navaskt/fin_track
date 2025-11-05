import 'package:fin_track/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/transactions/presentation/controllers/theme_provider.dart';

class ThemeSelector extends ConsumerWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    return PopupMenuButton(
      tooltip: context.loc.themeMenu,
      icon: Icon(Icons.brightness_6_outlined, color: cs.secondary),
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'light',
          child: Text(
            context.loc.themeLight,
            style: TextStyle(color: cs.primary),
          ),
        ),
        PopupMenuItem(
          value: 'dark',
          child: Text(
            context.loc.themeDark,
            style: TextStyle(color: cs.primary),
          ),
        ),
        PopupMenuItem(
          value: 'system',
          child: Text(
            context.loc.themeSystem,
            style: TextStyle(color: cs.primary),
          ),
        ),
      ],
      onSelected: (v) {
        final notifier = ref.read(themeModeProvider.notifier);
        if (v == 'light') notifier.state = ThemeMode.light;
        if (v == 'dark') notifier.state = ThemeMode.dark;
        if (v == 'system') notifier.state = ThemeMode.system;
      },
    );
  }
}
