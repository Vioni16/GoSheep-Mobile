import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xFF0F5132);
  static const Color primaryGreenDark = Color(0xFF1B5E20);
  static const Color brown = Color(0xFF8D6E63);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF0F5132)),

    scaffoldBackgroundColor: const Color(0xFFF5F4F0),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style:
          ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            textStyle: const TextStyle(fontSize: 16),
          ).copyWith(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return primaryGreenDark;
              }
              return primaryGreen;
            }),
          ),
    ),

    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 1,
    ),

    appBarTheme: const AppBarTheme(backgroundColor: Colors.white, elevation: 0),
  );
}
