import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../ui/styles/app_spacing.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    const seed = Color(0xFF0D9488);
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
      primary: const Color(0xFF0D9488),
      surface: const Color(0xFFF8FAFC),
    );
    return _buildTheme(scheme, Brightness.light);
  }

  static ThemeData get darkTheme {
    const seed = Color(0xFF14B8A6);
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
      primary: const Color(0xFF14B8A6),
      surface: const Color(0xFF0F172A),
    );
    return _buildTheme(scheme, Brightness.dark);
  }

  static ThemeData _buildTheme(ColorScheme scheme, Brightness brightness) {
    final fontFamily = GoogleFonts.plusJakartaSans().fontFamily;
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: brightness == Brightness.light
          ? const Color(0xFFF1F5F9)
          : const Color(0xFF0F172A),
      fontFamily: fontFamily,
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: scheme.onSurface,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: scheme.onSurfaceVariant,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: scheme.onSurface,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: scheme.onSurfaceVariant,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: scheme.onPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.r20),
        ),
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.horizontalPadding),
        clipBehavior: Clip.antiAlias,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.r16),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.r16),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.r16),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.r16),
          borderSide: BorderSide(
            color: scheme.outline.withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.r16),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
      ),
    );
  }
}

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
}
