import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/transactions/presentation/controllers/locale_provider.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(localeProvider);
    final notifier = ref.read(localeProvider.notifier);

    return PopupMenuButton<Locale>(
      tooltip: 'Change language',
      // ✅ use only icon, not both icon and child
      icon: const Icon(Icons.language_outlined),

      onSelected: (locale) => notifier.setLocale(locale),
      itemBuilder: (context) => const [
        PopupMenuItem(value: Locale('en', 'AE'), child: Text('English')),
        PopupMenuItem(value: Locale('ar', 'AE'), child: Text('العربية')),
        PopupMenuItem(value: Locale('hi', 'IN'), child: Text('हिंदी')),
      ],
    );
  }
}
