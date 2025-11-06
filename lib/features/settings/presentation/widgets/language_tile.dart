import 'package:fin_track/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../transactions/presentation/controllers/locale_provider.dart';


class LanguageTile extends ConsumerWidget {
  const LanguageTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final current = ref.watch(localeProvider);
    final notifier = ref.read(localeProvider.notifier);

    // Map available locales to a readable label
    final items = <Locale, String>{
      const Locale('en', 'AE'): 'English',
      const Locale('ar', 'AE'): 'العربية',
      const Locale('hi', 'IN'): 'हिंदी',
      const Locale('ml', 'IN'): 'മലയാളം',
    };

    String currentLabel = items[current] ?? 'English';

    return ListTile(
      leading: Icon(Icons.language_outlined, color: cs.primary),
      title: Text(context.loc.changeLanguage),
      subtitle: Text(currentLabel),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        final selected = await showModalBottomSheet<Locale>(
          context: context,
          showDragHandle: true,
          builder: (ctx) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView(
                shrinkWrap: true,
                children: items.entries.map((e) {
                  final isSelected = e.key == current;
                  return RadioListTile<Locale>(
                    value: e.key,
                    groupValue: current,
                    title: Text(e.value),
                    onChanged: (val) => Navigator.of(ctx).pop(val),
                    selected: isSelected,
                  );
                }).toList(),
              ),
            );
          },
        );

        if (selected != null) {
          await notifier.setLocale(selected);
        }
      },
    );
  }
}
