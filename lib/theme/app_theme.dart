import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF3DDC84),
      surface: Color(0xFF0D1117),
      surfaceContainerHighest: Color(0xFF161B22),
      onSurface: Color(0xFFE6EDF3),
      outlineVariant: Color(0xFF2D333B),
    ),
    scaffoldBackgroundColor: const Color(0xFF0D1117),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 46, height: 1.1),
      headlineSmall: TextStyle(fontSize: 34, height: 1.2),
      titleLarge: TextStyle(fontSize: 24),
      bodyLarge: TextStyle(fontSize: 18),
      bodyMedium: TextStyle(fontSize: 16),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3DDC84),
        foregroundColor: const Color(0xFF0D1117),
        elevation: 0,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFFE6EDF3),
        side: const BorderSide(color: Color(0xFF2D333B)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}