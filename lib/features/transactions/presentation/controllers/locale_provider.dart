import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';

final localeBoxProvider = Provider<Box<String>>((ref) {
  return Hive.box<String>('app_settings');
});

final localeProvider = StateNotifierProvider<LocaleController, Locale>((ref) {
  final box = ref.watch(localeBoxProvider);
  final saved = box.get('localeCode');
  final parts = saved?.split('_');
  final initial = (parts != null && parts.length == 2)
      ? Locale(parts[0], parts[1])
      : const Locale('en', 'AE'); // default to English (UAE)
  return LocaleController(box, initial);
});

class LocaleController extends StateNotifier<Locale> {
  LocaleController(this._box, Locale initial) : super(initial);
  final Box<String> _box;

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await _box.put(
      'localeCode',
      '${locale.languageCode}_${locale.countryCode}',
    );
  }
}
