import 'package:flutter/material.dart';

// Premium FinMate color system
const _seed = Color(0xFF00C853); // Emerald
const _gold = Color(0xFFFBC02D);

const _darkSurface = Color(0xFF181C1C);

// ---------- COLOR SCHEME TUNING ----------
ColorScheme _tunedScheme(Brightness brightness) {
  final base = ColorScheme.fromSeed(seedColor: _seed, brightness: brightness);

  if (brightness == Brightness.dark) {
    return base.copyWith(
      surface: _darkSurface,
      secondary: _gold,
      onSecondary: const Color(0xFF1C1C1C),
    );
  } else {
    return base.copyWith(
      secondary: _gold,
      onSecondary: const Color(0xFF1C1C1C),
    );
  }
}

// ---------- TEXT THEME ----------
TextTheme _montserratTextTheme(ColorScheme scheme) {
  return TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w700,
      fontSize: 28,
      color: scheme.onSurface,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w600,
      fontSize: 22,
      color: scheme.onBackground,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w600,
      fontSize: 18,
      color: scheme.onSurface,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w500,
      fontSize: 16,
      color: scheme.onSurfaceVariant,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w400,
      fontSize: 15,
      color: scheme.onSurface,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w400,
      fontSize: 13.5,
      color: scheme.onSurfaceVariant,
    ),
    labelLarge: TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w600,
      fontSize: 14,
      color: scheme.primary,
    ),
    labelMedium: TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w500,
      fontSize: 12.5,
      color: scheme.onSurfaceVariant,
    ),
  );
}

// ======================================================================
//                    FINMATE NUMBER THEME (ThemeExtension)
// ======================================================================
class FinMateNumberTheme extends ThemeExtension<FinMateNumberTheme> {
  final TextStyle amountXL; // e.g., large balance on dashboard
  final TextStyle amountL; // e.g., card totals
  final TextStyle amountM; // e.g., list items
  final TextStyle deltaPositive; // +2.3%
  final TextStyle deltaNegative; // -2.3%
  final TextStyle deltaNeutral; // 0.0% or unchanged

  const FinMateNumberTheme({
    required this.amountXL,
    required this.amountL,
    required this.amountM,
    required this.deltaPositive,
    required this.deltaNegative,
    required this.deltaNeutral,
  });

  // Build from a ColorScheme
  factory FinMateNumberTheme.fromScheme(ColorScheme scheme) {
    // Use tabular figures so columns align nicely
    const features = [FontFeature.tabularFigures()];

    // Choose red that works on both modes
    final lossRed = scheme.brightness == Brightness.dark
        ? const Color(0xFFFF6B6B)
        : const Color(0xFFD32F2F);

    return FinMateNumberTheme(
      amountXL: TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w700,
        fontSize: 30,
        letterSpacing: -0.2,
        color: scheme.onBackground,
        fontFeatures: features,
      ),
      amountL: TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w600,
        fontSize: 22,
        letterSpacing: -0.1,
        color: scheme.onSurface,
        fontFeatures: features,
      ),
      amountM: TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w600,
        fontSize: 17,
        color: scheme.onSurface,
        fontFeatures: features,
      ),
      deltaPositive: TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w600,
        fontSize: 14.5,
        color: scheme.primary, // emerald
        fontFeatures: features,
      ),
      deltaNegative: TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w600,
        fontSize: 14.5,
        color: lossRed,
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
    TextStyle _lerp(TextStyle a, TextStyle b) => TextStyle.lerp(a, b, t) ?? a;

    return FinMateNumberTheme(
      amountXL: _lerp(amountXL, other.amountXL),
      amountL: _lerp(amountL, other.amountL),
      amountM: _lerp(amountM, other.amountM),
      deltaPositive: _lerp(deltaPositive, other.deltaPositive),
      deltaNegative: _lerp(deltaNegative, other.deltaNegative),
      deltaNeutral: _lerp(deltaNeutral, other.deltaNeutral),
    );
  }
}

// Easy access from BuildContext
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
      scrolledUnderElevation: 2,
    ),
    cardTheme: CardThemeData(
      color: colorScheme.surfaceContainerHighest,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      iconColor: colorScheme.onSurfaceVariant,
      textColor: colorScheme.onSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    dividerTheme: DividerThemeData(
      color: colorScheme.outlineVariant,
      thickness: 1,
      space: 1,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimaryContainer,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          fontSize: 15,
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
      scrolledUnderElevation: 2,
    ),
    cardTheme: CardThemeData(
      color: colorScheme.surfaceContainerHighest,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      iconColor: colorScheme.onSurfaceVariant,
      textColor: colorScheme.onSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    dividerTheme: DividerThemeData(
      color: colorScheme.outlineVariant,
      thickness: 1,
      space: 1,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimaryContainer,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    ),
  );
}

// ======================================================================
//                     QUICK HELPERS FOR NUMBERS
// ======================================================================

// Formats a currency with alignment-friendly style.
// Example: FinMateAmount(amount: -1240.55, prefix: 'AED ')
class FinMateAmount extends StatelessWidget {
  const FinMateAmount({
    super.key,
    required this.amount,
    this.prefix = 'AED',
    this.textScale = 1.0,
    this.size = _AmountSize.lg,
  });

  final double amount;
  final String prefix;
  final double textScale;
  final _AmountSize size;

  @override
  Widget build(BuildContext context) {
    final numbers = context.finNumbers;
    final scheme = Theme.of(context).colorScheme;

    final style = switch (size) {
      _AmountSize.xl => numbers.amountXL,
      _AmountSize.lg => numbers.amountL,
      _AmountSize.md => numbers.amountM,
    };

    final color = amount < 0
        ? context.finNumbers.deltaNegative.color
        : scheme.onSurface;

    // You likely already have a formatter like formatAED(...)
    final text = '$prefix${_format(amount)}';

    return Text(
      text,
      textScaleFactor: textScale,
      style: style.copyWith(color: color),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  String _format(double value) {
    // Simple placeholder. Replace with your formatAED or NumberFormat if you use intl.
    final sign = value < 0 ? '-' : '';
    final abs = value.abs().toStringAsFixed(2);
    return '$sign$abs';
  }
}

enum _AmountSize { xl, lg, md }

// Shows a percent delta with colored sign and tabular digits
// Example: FinMateDelta(value: 0.0345) -> +3.45%
class FinMateDelta extends StatelessWidget {
  const FinMateDelta({
    super.key,
    required this.value,
    this.textScale = 1.0,
    this.showSign = true,
    this.decimals = 2,
  });

  final double value; // e.g., 0.0345 => 3.45%
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

    return Text(
      '$sign$pct%',
      textScaleFactor: textScale,
      style: style,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
