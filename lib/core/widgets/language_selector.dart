import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/transactions/presentation/controllers/locale_provider.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(localeProvider);
    final notifier = ref.read(localeProvider.notifier);
    final cs = Theme.of(context).colorScheme;

    return PopupMenuButton<Locale>(
      tooltip: 'Change language',
      icon: Icon(Icons.language_outlined, size: 24, color: cs.primary),

      onSelected: (locale) => notifier.setLocale(locale),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: Locale('en', 'AE'),
          child: Text('English', style: TextStyle(color: cs.primary)),
        ),
        PopupMenuItem(
          value: Locale('ar', 'AE'),
          child: Text('العربية', style: TextStyle(color: cs.primary)),
        ),
        PopupMenuItem(
          value: Locale('hi', 'IN'),
          child: Text('हिंदी', style: TextStyle(color: cs.primary)),
        ),
        PopupMenuItem(
          value: Locale('ml', 'IN'),
          child: Text('മലയാളം', style: TextStyle(color: cs.primary)),
        ),
      ],
    );
  }
}
