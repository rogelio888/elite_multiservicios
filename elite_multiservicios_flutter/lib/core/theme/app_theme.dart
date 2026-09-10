import 'package:flutter/material.dart';

/// Sistema de diseño visual y temas para Elite Multiservicios.
/// Diseñado con estándares de alta jerarquía visual y accesibilidad.
abstract class AppTheme {
  // Paleta de Colores Primaria
  static const Color primaryBlue = Color(0xFF1E3A8A); // Deep Royal Blue
  static const Color accentIndigo = Color(0xFF4F46E5);
  static const Color emeraldSuccess = Color(0xFF059669);
  static const Color amberWarning = Color(0xFFD97706);
  static const Color roseDanger = Color(0xFFE11D48);

  // Fondos y Superficies Modo Claro
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // Fondos y Superficies Modo Oscuro
  static const Color darkBg = Color(0xFF0B0F19);
  static const Color darkSurface = Color(0xFF111827);
  static const Color darkBorder = Color(0xFF1F2937);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  /// Tema Claro
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: accentIndigo,
        surface: lightSurface,
        error: roseDanger,
      ),
      scaffoldBackgroundColor: lightBg,
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: lightBorder),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: lightTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: lightTextPrimary),
      ),
    );
  }

  /// Tema Oscuro
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: accentIndigo,
        secondary: primaryBlue,
        surface: darkSurface,
        error: roseDanger,
      ),
      scaffoldBackgroundColor: darkBg,
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: darkBorder),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: darkTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: darkTextPrimary),
      ),
    );
  }
}
