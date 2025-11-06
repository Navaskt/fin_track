import 'package:fin_track/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/biometrics_tile.dart';
import '../widgets/export_tile.dart';
import '../widgets/language_tile.dart';
import '../widgets/theme_tile.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final headerStyle = theme.textTheme.titleLarge?.copyWith(
      color: cs.secondary,
    );
    const smallSpacing = SizedBox(height: 8);
    final loc = context.loc;

    final items = [
      // Security Section
      Text(loc.security, style: headerStyle),
      smallSpacing,
      const BiometricsTile(),
      smallSpacing,

      // Preferences Section
      Text(loc.preferences, style: headerStyle),
      smallSpacing,
      const ThemeTile(),
      const LanguageTile(),
      const ExportTile(),
      ListTile(
        title: Text(loc.changePin),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/set-pin'),
      ),

      // About Section
      Text(loc.about, style: headerStyle),
      smallSpacing,
      ListTile(
        title: Text(loc.appVersion),
        subtitle: Text('1.0.0'),
        leading: Icon(Icons.info_outline, color: cs.primary),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(loc.settings)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) => items[index],
        separatorBuilder: (context, index) {
          // Add a divider after specific items
          final item = items[index];
          if (item is BiometricsTile ||
              item is ThemeTile ||
              item is LanguageTile ||
              item is ExportTile) {
            return const Divider();
          }
          // Add larger spacing between sections
          if (item is ListTile &&
              item.title is Text &&
              (item.title as Text).data == loc.changePin) {
            return const SizedBox(height: 16);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
