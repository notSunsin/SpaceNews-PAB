import 'package:flutter/material.dart';

/// Centralized color & style tokens for SpaceNews Core.
/// Keeping these in one place makes it easy to re-theme the whole app.
class AppColors {
  AppColors._();

  // Primary brand palette — deep space navy + cosmic accent.
  static const Color primary = Color(0xFF1B1F3B);
  static const Color primaryDark = Color(0xFF11132A);
  static const Color accent = Color(0xFFFFC857);
  static const Color accentSoft = Color(0xFFFFE3A3);

  static const Color background = Color(0xFFF6F7FB);
  static const Color surface = Colors.white;

  static const Color textPrimary = Color(0xFF1B1F3B);
  static const Color textSecondary = Color(0xFF6B7088);
  static const Color textOnPrimary = Colors.white;

  static const Color error = Color(0xFFE05260);
  static const Color success = Color(0xFF3CB371);

  static const Color favoriteRed = Color(0xFFE53950);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );
}

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle heading1 = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
}

class AppSpacing {
  AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}
