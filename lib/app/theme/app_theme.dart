import 'package:fin_track/app/theme/app_colors.dart';
import 'package:flutter/material.dart';


// ── ColorScheme builder ───────────────────────────────────────────────────────
ColorScheme _tunedScheme(Brightness brightness) {
  final base = ColorScheme.fromSeed(
    seedColor: AppColors.crimsonPrimary,
    primary: AppColors.crimsonPrimary,
    onPrimary: Colors.white,
    brightness: brightness,
  );

  if (brightness == Brightness.dark) {
    return base.copyWith(
      primary: AppColors.crimsonDark,          // slightly deeper in dark mode
      onPrimary: AppColors.iconWhite,
      surface: AppColors.surfaceDark,          // deep dark background
      onSurface: AppColors.iconWhite,
      surfaceContainerHighest: AppColors.cardDark,
      secondary: AppColors.incomeDark,         // teal accent for income
      onSecondary: const Color(0xFF0D2018),
      outline: AppColors.borderDark,
      outlineVariant: AppColors.borderDark,
    );
  } else {
    return base.copyWith(
      surface: AppColors.surfaceLight,
      onSurface: const Color(0xFF1F2937),
      secondary: AppColors.incomeLight,        // green for income
      onSecondary: Colors.white,
    );
  }
}

// ── Text theme (Montserrat) ───────────────────────────────────────────────────
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
      color: scheme.onSurface,
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

// ── FinMate number extension ──────────────────────────────────────────────────
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
    final isDark = scheme.brightness == Brightness.dark;

    return FinMateNumberTheme(
      amountXL: TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w700,
        fontSize: 30,
        letterSpacing: -0.2,
        color: scheme.onSurface,
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
      // Positive = income = teal (not primary crimson — avoids confusion)
      deltaPositive: TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w600,
        fontSize: 14.5,
        color: isDark ? AppColors.incomeDark : AppColors.incomeLight,
        fontFeatures: features,
      ),
      // Negative = expense loss red
      deltaNegative: TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w600,
        fontSize: 14.5,
        color: isDark ? AppColors.lossDark : AppColors.lossLight,
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
    TextStyle? amountXL, TextStyle? amountL, TextStyle? amountM,
    TextStyle? deltaPositive, TextStyle? deltaNegative, TextStyle? deltaNeutral,
  }) => FinMateNumberTheme(
    amountXL: amountXL ?? this.amountXL,
    amountL: amountL ?? this.amountL,
    amountM: amountM ?? this.amountM,
    deltaPositive: deltaPositive ?? this.deltaPositive,
    deltaNegative: deltaNegative ?? this.deltaNegative,
    deltaNeutral: deltaNeutral ?? this.deltaNeutral,
  );

  @override
  FinMateNumberTheme lerp(ThemeExtension<FinMateNumberTheme>? other, double t) {
    if (other is! FinMateNumberTheme) return this;
    TextStyle lrp(TextStyle a, TextStyle b) => TextStyle.lerp(a, b, t) ?? a;
    return FinMateNumberTheme(
      amountXL: lrp(amountXL, other.amountXL),
      amountL: lrp(amountL, other.amountL),
      amountM: lrp(amountM, other.amountM),
      deltaPositive: lrp(deltaPositive, other.deltaPositive),
      deltaNegative: lrp(deltaNegative, other.deltaNegative),
      deltaNeutral: lrp(deltaNeutral, other.deltaNeutral),
    );
  }
}

extension FinMateNumberX on BuildContext {
  FinMateNumberTheme get finNumbers =>
      Theme.of(this).extension<FinMateNumberTheme>()!;
}

// ── Shared component theme builder ───────────────────────────────────────────
ThemeData _buildBase(ColorScheme colorScheme) => ThemeData(
  useMaterial3: true,
  colorScheme: colorScheme,
  textTheme: _montserratTextTheme(colorScheme),
  scaffoldBackgroundColor: colorScheme.surface,
  extensions: [FinMateNumberTheme.fromScheme(colorScheme)],
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
    backgroundColor: colorScheme.primary,
    foregroundColor: colorScheme.onPrimary,
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
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
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

ThemeData buildLightTheme() => _buildBase(_tunedScheme(Brightness.light));
ThemeData buildDarkTheme()  => _buildBase(_tunedScheme(Brightness.dark));

// ── Amount & Delta widgets (unchanged API) ────────────────────────────────────
class FinMateAmount extends StatelessWidget {
  const FinMateAmount({
    super.key,
    required this.amount,
    this.prefix = 'AED ',
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
        ? numbers.deltaNegative.color
        : scheme.onSurface;
    return Text(
      '$prefix${_format(amount)}',
      textScaleFactor: textScale,
      style: style.copyWith(color: color),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  String _format(double value) {
    final sign = value < 0 ? '-' : '';
    return '$sign${value.abs().toStringAsFixed(2)}';
  }
}

enum _AmountSize { xl, lg, md }

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
    final style = value > 0
        ? numbers.deltaPositive
        : value < 0
            ? numbers.deltaNegative
            : numbers.deltaNeutral;
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