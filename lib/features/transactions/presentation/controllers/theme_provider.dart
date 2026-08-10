// theme_mode_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';

final themeBoxProvider = Provider<Box<int>>((_) => Hive.box<int>('theme_mode'));

final themeModeProvider = StateNotifierProvider<ThemeController, ThemeMode>((ref) {
  final box = ref.watch(themeBoxProvider);
  final saved = box.get('current_theme_mode', defaultValue: ThemeMode.dark.index);
  return ThemeController(ThemeMode.values[saved ?? ThemeMode.dark.index]);
});


class ThemeController extends StateNotifier<ThemeMode> {
  ThemeController(super.state);

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final box = Hive.box<int>('theme_mode');
    await box.put('current_theme_mode', mode.index);
  }
}