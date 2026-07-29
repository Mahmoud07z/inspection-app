import 'package:flutter/material.dart';
import 'package:inspection_app/core/theme/app_colors.dart';

<<<<<<< HEAD
abstract final class AppTheme {
  static const double _r = 12.0;
=======
/// Factory that produces [ThemeData] for both light and dark modes.
/// Every visual decision (radius, elevation, colour scheme, component defaults)
/// lives here so that widgets stay theme-agnostic.
abstract final class AppTheme {
  static const double _radius = 12.0;
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1

  static ThemeData light() => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      elevation: 2,
<<<<<<< HEAD
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_r)),
=======
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radius),
      ),
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
<<<<<<< HEAD
        borderRadius: BorderRadius.circular(_r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_r),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_r),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_r),
=======
        borderRadius: BorderRadius.circular(_radius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        minimumSize: const Size(double.infinity, 52),
<<<<<<< HEAD
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_r)),
        elevation: 0,
      ),
    ),
=======
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
        elevation: 0,
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
  );

  static ThemeData dark() => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surfaceDark,
      elevation: 0,
<<<<<<< HEAD
=======
      centerTitle: false,
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardDark,
      elevation: 0,
<<<<<<< HEAD
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_r)),
=======
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radius),
      ),
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
    ),
  );
}
