import 'package:fin_track/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../transactions/presentation/controllers/theme_provider.dart';

class ThemeTile extends ConsumerWidget {
  const ThemeTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final mode = ref.watch(themeModeProvider);

    String labelFor(ThemeMode m) {
      if (m == ThemeMode.light) return context.loc.themeLight;
      if (m == ThemeMode.dark) return context.loc.themeDark;
      return context.loc.themeSystem;
    }

    return ListTile(
      leading: Icon(Icons.brightness_6_outlined, color: cs.primary),
      title: Text(context.loc.themeMenu),
      subtitle: Text(labelFor(mode)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        final selected = await showModalBottomSheet<String>(
          context: context,
          showDragHandle: true,
          builder: (ctx) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  value: 'light',
                  groupValue: _groupValue(mode),
                  title: Text(context.loc.themeLight),
                  onChanged: (v) => Navigator.of(ctx).pop(v),
                ),
                RadioListTile<String>(
                  value: 'dark',
                  groupValue: _groupValue(mode),
                  title: Text(context.loc.themeDark),
                  onChanged: (v) => Navigator.of(ctx).pop(v),
                ),
                RadioListTile<String>(
                  value: 'system',
                  groupValue: _groupValue(mode),
                  title: Text(context.loc.themeSystem),
                  onChanged: (v) => Navigator.of(ctx).pop(v),
                ),
                const SizedBox(height: 8),
              ],
            );
          },
        );

        if (selected != null) {
          final notifier = ref.read(themeModeProvider.notifier);
          if (selected == 'light') notifier.state = ThemeMode.light;
          if (selected == 'dark') notifier.state = ThemeMode.dark;
          if (selected == 'system') notifier.state = ThemeMode.system;
        }
      },
    );
  }

  String _groupValue(ThemeMode m) {
    switch (m) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
