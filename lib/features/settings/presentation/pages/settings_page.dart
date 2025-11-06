import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/biometrics_tile.dart';
import '../widgets/language_tile.dart';
import '../widgets/theme_tile.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const headerStyle = TextStyle(fontWeight: FontWeight.w600);
    const smallSpacing = SizedBox(height: 8);

    final items = [
      // Security Section
      const Text('Security', style: headerStyle),
      smallSpacing,
      const BiometricsTile(),
      smallSpacing,

      // Preferences Section
      const Text('Preferences', style: headerStyle),
      smallSpacing,
      const ThemeTile(),
      const LanguageTile(),
      ListTile(
        title: const Text('Change PIN'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/set-pin'),
      ),

      // About Section
      const Text('About', style: headerStyle),
      smallSpacing,
      const ListTile(
        title: Text('App Version'),
        subtitle: Text('1.0.0'),
        leading: Icon(Icons.info_outline),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) => items[index],
        separatorBuilder: (context, index) {
          // Add a divider after specific items
          final item = items[index];
          if (item is BiometricsTile ||
              item is ThemeTile ||
              item is LanguageTile) {
            return const Divider();
          }
          // Add larger spacing between sections
          if (item is ListTile &&
              item.title is Text &&
              (item.title as Text).data == 'Change PIN') {
            return const SizedBox(height: 16);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
