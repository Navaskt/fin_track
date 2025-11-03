// theme_mode_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final themeModeProvider = StateProvider<ThemeMode>((_) => ThemeMode.system);
