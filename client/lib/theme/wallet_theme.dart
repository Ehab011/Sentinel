import 'package:flutter/material.dart';

const Color walletAccent = Color(0xFF0A8F7A);

const Color lightBackground = Color(0xFFF5F5F7);
const Color lightSurface = Color(0xFFFFFFFF);
const Color lightBorder = Color(0xFFE5E5EA);
const Color lightSecondary = Color(0xFF6E6E73);
const Color lightPrimary = Color(0xFF1C1C1E);

const Color darkBackground = Color(0xFF000000);
const Color darkSurface = Color(0xFF1C1C1E);
const Color darkBorder = Color(0xFF2C2C2E);
const Color darkSecondary = Color(0xFF8E8E93);
const Color darkPrimary = Color(0xFFFFFFFF);

class WalletTheme {
  WalletTheme._();

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: walletAccent,
        onPrimary: Colors.white,
        surface: lightSurface,
        onSurface: lightPrimary,
        surfaceContainerHighest: lightBackground,
        outline: lightBorder,
        error: const Color(0xFFE53935),
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: lightBackground,
      dividerColor: lightBorder,
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),
      listTileTheme: const ListTileThemeData(
        dense: false,
        contentPadding: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: lightBorder, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: walletAccent, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: walletAccent,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: walletAccent,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      dividerTheme: const DividerThemeData(thickness: 0.5, color: lightBorder),
      appBarTheme: AppBarTheme(
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: lightPrimary,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: lightPrimary),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: lightPrimary),
        titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: lightPrimary),
        bodyLarge: TextStyle(fontSize: 16, color: lightPrimary),
        bodyMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: lightSecondary),
        bodySmall: TextStyle(fontSize: 14, color: lightSecondary),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: lightSecondary),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: walletAccent,
        onPrimary: Colors.white,
        surface: darkSurface,
        onSurface: darkPrimary,
        surfaceContainerHighest: darkBackground,
        outline: darkBorder,
        error: const Color(0xFFEF5350),
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: darkBackground,
      dividerColor: darkBorder,
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
          side: const BorderSide(color: darkBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),
      listTileTheme: const ListTileThemeData(
        dense: false,
        contentPadding: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: darkBorder, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: walletAccent, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: walletAccent,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: walletAccent,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      dividerTheme: const DividerThemeData(thickness: 0.5, color: darkBorder),
      appBarTheme: AppBarTheme(
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: darkPrimary,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: darkPrimary),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: darkPrimary),
        titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: darkPrimary),
        bodyLarge: TextStyle(fontSize: 16, color: darkPrimary),
        bodyMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: darkSecondary),
        bodySmall: TextStyle(fontSize: 14, color: darkSecondary),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: darkSecondary),
      ),
    );
  }
}
