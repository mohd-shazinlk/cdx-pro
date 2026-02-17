import 'package:flutter/material.dart';

class AppTheme {
  static const _royalBlue = Color(0xFF244CFF);
  static const _deepDark = Color(0xFF0A0D1A);

  static ThemeData get darkRoyalTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _deepDark,
      colorScheme: const ColorScheme.dark(
        primary: _royalBlue,
        secondary: Color(0xFF5F7CFF),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  static const appGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0B1024), Color(0xFF111D45), Color(0xFF1E40AF)],
  );
}
