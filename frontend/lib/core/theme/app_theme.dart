import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'app_spacing.dart';

class AppTheme {
  // ── Raw colours (Referencing centralized AppColors) ──────────────────────────
  static const Color deepCharcoal = AppColors.deepCharcoal;
  static const Color slateGrey = AppColors.slateGrey;
  static const Color teal = AppColors.teal;
  static const Color offWhite = AppColors.offWhite;

  // ── Shared helpers ────────────────────────────────────────────────────────────
  static const _shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(AppSpacing.sm)),
  );

  // ── Input decoration (parameterised by surface colour) ───────────────────────
  static InputDecorationTheme _inputTheme(Color fill, Color text) =>
      InputDecorationTheme(
        filled: true,
        fillColor: fill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sl,
        ),
        hintStyle: TextStyle(color: text.withValues(alpha: 0.4)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          borderSide: const BorderSide(color: teal, width: 2),
        ),
      );

  // ── Shared button themes ──────────────────────────────────────────────────────
  static final _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: teal,
      foregroundColor: offWhite,
      minimumSize: const Size(double.infinity, AppSpacing.jm),
      shape: _shape,
      elevation: 0,
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  );

  static final _outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: teal,
      minimumSize: const Size(double.infinity, AppSpacing.jm),
      shape: _shape,
      side: const BorderSide(color: teal, width: 1.5),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  );

  static final _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: teal,
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
  );

  // ─────────────────────────────────────────────────────────────────────────────
  // DARK THEME
  // Background: #222831 | Surfaces: #393E46 | Accent: #00ADB5 | Text: #EEEEEE
  // ─────────────────────────────────────────────────────────────────────────────
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: deepCharcoal,
    primaryColor: teal,
    secondaryHeaderColor: slateGrey,
    colorScheme: const ColorScheme.dark(
      primary: teal,
      onPrimary: offWhite,
      secondary: slateGrey,
      onSecondary: offWhite,
      surface: slateGrey,
      onSurface: offWhite,
      error: AppColors.errorDark,
      onError: offWhite,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: deepCharcoal,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: offWhite),
      titleTextStyle: TextStyle(
        color: offWhite,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      shape: Border(bottom: BorderSide(color: slateGrey, width: 1.5)),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: offWhite, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: offWhite, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: offWhite, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(color: offWhite, fontWeight: FontWeight.w700),
      headlineMedium: TextStyle(color: offWhite, fontWeight: FontWeight.w700),
      headlineSmall: TextStyle(color: offWhite, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: offWhite, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: offWhite),
      titleSmall: TextStyle(color: offWhite),
      bodyLarge: TextStyle(color: offWhite),
      bodyMedium: TextStyle(color: offWhite, fontSize: 14),
      bodySmall: TextStyle(color: AppColors.textDimDark, fontSize: 12),
      labelLarge: TextStyle(color: offWhite, fontWeight: FontWeight.w600),
    ),
    cardTheme: const CardThemeData(
      color: slateGrey,
      elevation: 0,
      shape: _shape,
    ),
    dividerColor: slateGrey,
    inputDecorationTheme: _inputTheme(slateGrey, offWhite),
    elevatedButtonTheme: _elevatedButtonTheme,
    outlinedButtonTheme: _outlinedButtonTheme,
    textButtonTheme: _textButtonTheme,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: deepCharcoal,
      selectedItemColor: teal,
      unselectedItemColor: AppColors.offWhite60, // offWhite with ~60% opacity
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );

  // ─────────────────────────────────────────────────────────────────────────────
  // LIGHT THEME
  // Background: #EEEEEE | Surfaces: white | Accent: #00ADB5 | Text: #222831
  // ─────────────────────────────────────────────────────────────────────────────
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: offWhite,
    primaryColor: teal,
    secondaryHeaderColor: slateGrey,
    colorScheme: const ColorScheme.light(
      primary: teal,
      onPrimary: offWhite,
      secondary: slateGrey,
      onSecondary: offWhite,
      surface: AppColors.white,
      onSurface: deepCharcoal,
      error: AppColors.errorLight,
      onError: offWhite,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: offWhite,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: deepCharcoal),
      titleTextStyle: TextStyle(
        color: deepCharcoal,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      shape: Border(
        bottom: BorderSide(color: AppColors.borderLight, width: 1.5),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: deepCharcoal, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(
        color: deepCharcoal,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(color: deepCharcoal, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(
        color: deepCharcoal,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        color: deepCharcoal,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: TextStyle(
        color: deepCharcoal,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(color: deepCharcoal, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: deepCharcoal),
      titleSmall: TextStyle(color: deepCharcoal),
      bodyLarge: TextStyle(color: deepCharcoal),
      bodyMedium: TextStyle(color: deepCharcoal, fontSize: 14),
      bodySmall: TextStyle(color: slateGrey, fontSize: 12),
      labelLarge: TextStyle(color: deepCharcoal, fontWeight: FontWeight.w600),
    ),
    cardTheme: const CardThemeData(
      color: AppColors.white,
      elevation: 0,
      shape: _shape,
    ),
    dividerColor: AppColors.borderLight,
    inputDecorationTheme: _inputTheme(AppColors.inputFillLight, deepCharcoal),
    elevatedButtonTheme: _elevatedButtonTheme,
    outlinedButtonTheme: _outlinedButtonTheme,
    textButtonTheme: _textButtonTheme,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: offWhite,
      selectedItemColor: teal,
      unselectedItemColor:
          AppColors.deepCharcoal60, // deepCharcoal with ~60% opacity
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );
}
