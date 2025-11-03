import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme(this.light, this.dark);
  final ThemeData light;
  final ThemeData dark;
}

AppTheme buildAppTheme() {
  const seed = Color(0xFF3F51B5);
  final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
    ),
  );
  final dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
    ),
  );
  return AppTheme(light, dark);
}
