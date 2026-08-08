import 'package:fin_track/core/extensions/spacing_extension.dart';
import 'package:flutter/material.dart';

// ======================================================================
//                  PREMIUM FINTRACK VIBRANT COLOR SYSTEM
// ======================================================================
const _seed = Color(0xFF4F38FF); // Vibrant Electric Indigo — primary
const _accent = Color(0xFFFF3366); // Neon Rose — secondary accent
const _success = Color(0xFF00E396); // Luminous Mint — gains/positive deltas
const _loss = Color(0xFFFF4560); // Vivid Coral Red - losses/negative deltas

const _darkSurface = Color(0xFF0B0D14); // Deep Midnight - OLED friendly premium dark
const _lightSurface = Color(0xFFF4F6FA); // Cool Tinted White - makes white cards pop

// ---------- COLOR SCHEME TUNING ----------
ColorScheme _tunedScheme(Brightness brightness) {
  final base = ColorScheme.fromSeed(
    seedColor: _seed,
    brightness: brightness,
    // Slightly tweak the contrast of the generated scheme
    dynamicSchemeVariant: DynamicSchemeVariant.fidelity, 
  );

  if (brightness == Brightness.dark) {
    return base.copyWith(
      primary: _seed,
      surface: _darkSurface,
      surfaceContainerHighest: const Color(0xFF161824), // Slightly lighter for cards
      secondary: _accent,
      onSecondary: Colors.white,
    );
  } else {
    return base.copyWith(
      primary: _seed,
      surface: _lightSurface,
      surfaceContainerHighest: Colors.white, // Pure white cards on light surface
      secondary: _accent,
      onSecondary: Colors.white,
    );
  }
}

// ---------- TEXT THEME ----------
TextTheme _montserratTextTheme(ColorScheme scheme) {
  return TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w800, // Slightly bolder for massive numbers
      fontSize: 28,
      color: scheme.onSurface,
      letterSpacing: -0.5,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w700,
      fontSize: 22,
      color: scheme.onSurface,
      letterSpacing: -0.3,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w600,
      fontSize: 18,
      color: scheme.onSurface,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: scheme.onSurfaceVariant,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w500,
      fontSize: 15,
      color: scheme.onSurface,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w500,
      fontSize: 13.5,
      color: scheme.onSurfaceVariant,
    ),
    labelLarge: TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w700,
      fontSize: 14,
      color: scheme.primary,
      letterSpacing: 0.5,
    ),
    labelMedium: TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w600,
      fontSize: 12.5,
      color: scheme.onSurfaceVariant,
    ),
  );
}

// ======================================================================
//                    FINMATE NUMBER THEME (ThemeExtension)
// ======================================================================
class FinMateNumberTheme extends ThemeExtension<FinMateNumberTheme> {
  final TextStyle amountXL;
  final TextStyle amountL;
  final TextStyle amountM;
  final TextStyle deltaPositive;
  final TextStyle deltaNegative;
  final TextStyle deltaNeutral;

  const FinMateNumberTheme({
    required this.amountXL,
    required this.amountL,
    required this.amountM,
    required this.deltaPositive,
    required this.deltaNegative,
    required this.deltaNeutral,
  });

  factory FinMateNumberTheme.fromScheme(ColorScheme scheme) {
    const features = [FontFeature.tabularFigures()];

    return FinMateNumberTheme(
      amountXL: TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w800,
        fontSize: 32,
        letterSpacing: -0.5,
        color: scheme.onSurface,
        fontFeatures: features,
      ),
      amountL: TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w700,
        fontSize: 24,
        letterSpacing: -0.2,
        color: scheme.onSurface,
        fontFeatures: features,
      ),
      amountM: TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: scheme.onSurface,
        fontFeatures: features,
      ),
      deltaPositive: TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w700,
        fontSize: 14.5,
        color: _success,
        fontFeatures: features,
      ),
      deltaNegative: TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w700,
        fontSize: 14.5,
        color: _loss,
        fontFeatures: features,
      ),
      deltaNeutral: TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w600,
        fontSize: 14.5,
        color: scheme.onSurfaceVariant,
        fontFeatures: features,
      ),
    );
  }

  @override
  FinMateNumberTheme copyWith({
    TextStyle? amountXL,
    TextStyle? amountL,
    TextStyle? amountM,
    TextStyle? deltaPositive,
    TextStyle? deltaNegative,
    TextStyle? deltaNeutral,
  }) {
    return FinMateNumberTheme(
      amountXL: amountXL ?? this.amountXL,
      amountL: amountL ?? this.amountL,
      amountM: amountM ?? this.amountM,
      deltaPositive: deltaPositive ?? this.deltaPositive,
      deltaNegative: deltaNegative ?? this.deltaNegative,
      deltaNeutral: deltaNeutral ?? this.deltaNeutral,
    );
  }

  @override
  FinMateNumberTheme lerp(ThemeExtension<FinMateNumberTheme>? other, double t) {
    if (other is! FinMateNumberTheme) return this;
    TextStyle lerp(TextStyle a, TextStyle b) => TextStyle.lerp(a, b, t) ?? a;

    return FinMateNumberTheme(
      amountXL: lerp(amountXL, other.amountXL),
      amountL: lerp(amountL, other.amountL),
      amountM: lerp(amountM, other.amountM),
      deltaPositive: lerp(deltaPositive, other.deltaPositive),
      deltaNegative: lerp(deltaNegative, other.deltaNegative),
      deltaNeutral: lerp(deltaNeutral, other.deltaNeutral),
    );
  }
}

extension FinMateNumberX on BuildContext {
  FinMateNumberTheme get finNumbers =>
      Theme.of(this).extension<FinMateNumberTheme>()!;
}

// ======================================================================
//                               THEMES
// ======================================================================
ThemeData buildLightTheme() {
  final colorScheme = _tunedScheme(Brightness.light);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: _montserratTextTheme(colorScheme),
    scaffoldBackgroundColor: colorScheme.surface,
    extensions: <ThemeExtension<dynamic>>[
      FinMateNumberTheme.fromScheme(colorScheme),
    ],
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      scrolledUnderElevation: 0, // Removed scroll shadow for a cleaner modern look
    ),
    cardTheme: CardThemeData(
      color: colorScheme.surfaceContainerHighest,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Slightly rounder for modern feel
        side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.3)), // Subtle border
      ),
      margin: EdgeInsets.zero,
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: 16.padH + 8.padV, // Increased breathing room
      iconColor: colorScheme.onSurfaceVariant,
      textColor: colorScheme.onSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    dividerTheme: DividerThemeData(
      color: colorScheme.outlineVariant.withOpacity(0.5),
      thickness: 1,
      space: 1,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorScheme.secondary, // Use vibrant accent for FAB
      foregroundColor: colorScheme.onSecondary,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: colorScheme.onSurfaceVariant,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none, // Removed border in favor of pure fill
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
      ),
      contentPadding: 16.padH + 14.padV,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: 16.padH + 16.padV, // Taller buttons
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
          fontSize: 16,
          letterSpacing: 0.5,
        ),
      ),
    ),
  );
}

ThemeData buildDarkTheme() {
  final colorScheme = _tunedScheme(Brightness.dark);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: _montserratTextTheme(colorScheme),
    scaffoldBackgroundColor: colorScheme.surface,
    extensions: <ThemeExtension<dynamic>>[
      FinMateNumberTheme.fromScheme(colorScheme),
    ],
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      scrolledUnderElevation: 0,
    ),
    cardTheme: CardThemeData(
      color: colorScheme.surfaceContainerHighest,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.1)),
      ),
      margin: EdgeInsets.zero,
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: 16.padH + 8.padV,
      iconColor: colorScheme.onSurfaceVariant,
      textColor: colorScheme.onSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    dividerTheme: DividerThemeData(
      color: colorScheme.outlineVariant.withOpacity(0.3),
      thickness: 1,
      space: 1,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorScheme.secondary, 
      foregroundColor: colorScheme.onSecondary,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: colorScheme.onSurfaceVariant,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
      ),
      contentPadding: 16.padH + 14.padV,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: 16.padH + 16.padV,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
          fontSize: 16,
          letterSpacing: 0.5,
        ),
      ),
    ),
  );
}

// ======================================================================
//                     QUICK HELPERS FOR NUMBERS
// ======================================================================

class FinMateAmount extends StatelessWidget {
  const FinMateAmount({
    super.key,
    required this.amount,
    this.prefix = 'AED',
    this.textScale = 1.0,
    this.size = AmountSize.lg,
  });

  final double amount;
  final String prefix;
  final double textScale;
  final AmountSize size;

  @override
  Widget build(BuildContext context) {
    final numbers = context.finNumbers;
    final scheme = Theme.of(context).colorScheme;

    final style = switch (size) {
      AmountSize.xl => numbers.amountXL,
      AmountSize.lg => numbers.amountL,
      AmountSize.md => numbers.amountM,
    };

    final color = amount < 0
        ? context.finNumbers.deltaNegative.color
        : scheme.onSurface;

    final text = '$prefix ${_format(amount)}'; // Added a space after prefix for cleaner reading

    return Text(
      text,
      textScaler: TextScaler.linear(textScale),
      style: style.copyWith(color: color),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  String _format(double value) {
    final sign = value < 0 ? '-' : '';
    final abs = value.abs().toStringAsFixed(2);
    // Optional: You could add a NumberFormat here if you want comma grouping for thousands!
    return '$sign$abs';
  }
}

enum AmountSize { xl, lg, md }

class FinMateDelta extends StatelessWidget {
  const FinMateDelta({
    super.key,
    required this.value,
    this.textScale = 1.0,
    this.showSign = true,
    this.decimals = 2,
  });

  final double value;
  final double textScale;
  final bool showSign;
  final int decimals;

  @override
  Widget build(BuildContext context) {
    final numbers = context.finNumbers;

    late final TextStyle style;
    if (value > 0) {
      style = numbers.deltaPositive;
    } else if (value < 0) {
      style = numbers.deltaNegative;
    } else {
      style = numbers.deltaNeutral;
    }

    final sign = showSign && value != 0 ? (value > 0 ? '+' : '-') : '';
    final pct = (value.abs() * 100).toStringAsFixed(decimals);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: style.color?.withOpacity(0.15), // Gives the delta a nice pill background
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$sign$pct%',
        textScaler: TextScaler.linear(textScale),
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}