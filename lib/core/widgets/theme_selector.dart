import 'package:fin_track/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/transactions/presentation/controllers/theme_provider.dart';

class ThemeSelector extends ConsumerWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
      tooltip: context.loc.themeMenu,
      icon: const Icon(Icons.brightness_6_outlined),
      itemBuilder: (_) => [
        PopupMenuItem(value: 'light', child: Text(context.loc.themeLight)),
        PopupMenuItem(value: 'dark', child: Text(context.loc.themeDark)),
        PopupMenuItem(value: 'system', child: Text(context.loc.themeSystem)),
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
