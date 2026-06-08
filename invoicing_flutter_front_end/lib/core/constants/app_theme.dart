import 'package:flutter/material.dart';

class AppColors {
  // ── Brand ──────────────────────────────────────────────────────────────
  static const Color primary        = Color(0xFF3ECFB2); // teal – main CTA
  static const Color primaryDark    = Color(0xFF29B89C); // teal pressed/hover
  static const Color primaryLight   = Color(0xFF6EDFD0); // teal light tint

  // ── Backgrounds ────────────────────────────────────────────────────────
  static const Color background     = Color(0xFF0D1B2A); // deep navy fallback
  static const Color surface        = Color(0xFF132030); // card / sheet bg
  static const Color cardBg         = Color(0xFF1C2D3E); // elevated card

  // ── Overlay gradients (used in landing) ────────────────────────────────
  static const Color overlayTop     = Color(0x22000000); // nearly clear
  static const Color overlayMid     = Color(0xCC000000); // mid-dark
  static const Color overlayBottom  = Color(0xF2000000); // near-opaque

  // ── Text ───────────────────────────────────────────────────────────────
  static const Color textDark       = Color(0xFF1A1A2E); // on-light text
  static const Color textLight      = Color(0xFFFFFFFF); // on-dark text
  static const Color textGrey       = Color(0xFF8A96A3); // secondary text
  static const Color textMuted      = Color(0x99FFFFFF); // 60 % white

  // ── Semantic ───────────────────────────────────────────────────────────
  static const Color success        = Color(0xFF10B981);
  static const Color error          = Color(0xFFEF4444);
  static const Color warning        = Color(0xFFF59E0B);

  // ── UI chrome ──────────────────────────────────────────────────────────
  static const Color divider        = Color(0xFF2A3D50);
  static const Color chipBorder     = Color(0x40FFFFFF); // 25 % white
  static const Color chipFill       = Color(0x1FFFFFFF); // 12 % white
  static const Color pillBg         = Color(0xFFFFFFFF);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textLight,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textLight,
            side: const BorderSide(color: AppColors.chipBorder, width: 1.5),
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          labelStyle: const TextStyle(color: AppColors.textGrey),
          hintStyle: const TextStyle(color: AppColors.textGrey),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        cardTheme: CardThemeData(
          color: AppColors.cardBg,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        useMaterial3: true,
      );
}