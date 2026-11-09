import 'package:flutter/material.dart';
import 'package:inspection_app/core/theme/app_colors.dart';

/// Factory that produces [ThemeData] for both light and dark modes.
/// Every visual decision (radius, elevation, colour scheme, component defaults)
/// lives here so that widgets stay theme-agnostic.
final class AppTheme {
  static const double _radius = 14.0;

  static ThemeData light() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.backgroundLight,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primaryDark,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: AppColors.primaryDark,
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
            side: const BorderSide(color: Color(0xFFE5EBF0)),
          ),
        ),
        dialogTheme: DialogThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
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
            borderSide: const BorderSide(color: AppColors.error),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_radius),
            ),
            elevation: 0,
          ),
        ),
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

  static ThemeData dark() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryLight,
          brightness: Brightness.dark,
        ).copyWith(
          primary: const Color(0xFF86D7C9),
          onPrimary: const Color(0xFF08231F),
          secondary: const Color(0xFF9BC9E1),
          onSecondary: const Color(0xFF122A39),
          surface: AppColors.surfaceDark,
          onSurface: AppColors.textPrimaryDark,
          onSurfaceVariant: AppColors.textSecondaryDark,
          outline: const Color(0xFF71838F),
          outlineVariant: AppColors.outlineDark,
          surfaceContainerHighest: AppColors.cardDark,
        ),
        scaffoldBackgroundColor: AppColors.backgroundDark,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surfaceDark,
          foregroundColor: AppColors.textPrimaryDark,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: AppColors.textPrimaryDark,
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.cardDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
            side: const BorderSide(color: AppColors.outlineDark),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.cardDark,
          labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
          hintStyle: const TextStyle(color: AppColors.textSecondaryDark),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_radius),
            borderSide: const BorderSide(color: AppColors.outlineDark),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_radius),
            borderSide: const BorderSide(color: AppColors.outlineDark),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_radius),
            borderSide: const BorderSide(color: Color(0xFF86D7C9), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_radius),
            borderSide: const BorderSide(color: Color(0xFFFFB4AB)),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF86D7C9),
            foregroundColor: const Color(0xFF08231F),
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_radius)),
            elevation: 0,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF86D7C9),
            foregroundColor: const Color(0xFF08231F),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_radius)),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textPrimaryDark,
            side: const BorderSide(color: AppColors.outlineDark),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_radius)),
          ),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.cardDark,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: const TextStyle(
            color: AppColors.textPrimaryDark,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          contentTextStyle: const TextStyle(color: AppColors.textSecondaryDark),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_radius)),
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: AppColors.surfaceDark,
          surfaceTintColor: Colors.transparent,
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: AppColors.textSecondaryDark,
          textColor: AppColors.textPrimaryDark,
        ),
        dividerTheme: const DividerThemeData(color: AppColors.outlineDark),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF86D7C9),
          foregroundColor: Color(0xFF08231F),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.cardDark,
          side: const BorderSide(color: AppColors.outlineDark),
          labelStyle: const TextStyle(color: AppColors.textPrimaryDark),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
}
