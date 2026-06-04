import 'package:flutter/material.dart';

class AppColors {
  // ── Spendly brand tokens ──────────────────────────────────────────────────────
  static const Color crimsonPrimary  = Color(0xFFB71C2E); // icon background red
  static const Color crimsonDark     = Color(0xFF8B1220); // icon wallet detail / dark primary
  static const Color crimsonTint     = Color(0xFFFDF0F2); // light surfaces / chip fills

  static const Color surfaceLight    = Color(0xFFF9F7F5); // warm off-white scaffold (light)
  static const Color surfaceDark     = Color(0xFF1A0A0E); // deep crimson-tinted black (dark)
  static const Color cardDark        = Color(0xFF2A1018); // elevated card surface (dark)
  static const Color borderDark      = Color(0xFF3D1420); // dividers / card borders (dark)

  static const Color iconWhite       = Color(0xFFF0EEEC); // matches icon circle fill

  // ── Income accent (teal-green — contrasts cleanly with crimson) ───────────────
  static const Color incomeLight     = Color(0xFF2E7D52);
  static const Color incomeDark      = Color(0xFF5DCAA5);

  // ── Loss red for dark mode (softened so it doesn't clash with primary) ────────
  static const Color lossLight       = Color(0xFFD32F2F);
  static const Color lossDark        = Color(0xFFFF6B6B);
}