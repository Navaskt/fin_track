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
      return switch (m) {
        ThemeMode.light => context.loc.themeLight,
        ThemeMode.dark => context.loc.themeDark,
        ThemeMode.system => context.loc.themeSystem,
      };
    }

    return ListTile(
      leading: Icon(Icons.brightness_6_outlined, color: cs.primary),
      title: Text(context.loc.themeMenu),
      subtitle: Text(labelFor(mode)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        final selected = await showModalBottomSheet<ThemeMode>(
          context: context,
          showDragHandle: true,
          builder: (ctx) {
            final options = {
              ThemeMode.light: context.loc.themeLight,
              ThemeMode.dark: context.loc.themeDark,
              ThemeMode.system: context.loc.themeSystem,
            };

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...options.entries.map((entry) {
                  final isSelected = entry.key == mode;
                  return RadioListTile<ThemeMode>(
                    value: entry.key,
                    groupValue: mode,
                    title: Text(entry.value),
                    onChanged: (v) => Navigator.of(ctx).pop(v),
                    selected: isSelected,
                  );
                }),
                const SizedBox(height: 8),
              ],
            );
          },
        );

        if (selected != null && selected != mode) {
          ref.read(themeModeProvider.notifier).state = selected;
        }
      },
    );
  }
}
