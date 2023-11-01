// theme_light.dart
import 'package:flutter/material.dart';

ThemeData themeLight(ColorScheme colorScheme) {
  // Bleu
  // ColorScheme colorScheme = const ColorScheme.light(
  //   primary: Color(0xFF0056D2),
  //   primaryContainer: Color(0xFFD6E4FF),
  //   secondary: Color(0xFF007BFF),
  //   secondaryContainer: Color(0xFFCCE0FF),
  //   background: Color(0xFFF3F4F6),
  //   surface: Colors.white,
  //   error: Colors.redAccent,
  //   onPrimary: Colors.white,
  //   onSecondary: Colors.white,
  //   onBackground: Colors.black,
  //   onSurface: Colors.black,
  //   onError: Colors.white,
  // );

  // Orange et marron
  // ColorScheme colorScheme = const ColorScheme.light(
  //   primary: Color(0xFFFF8A65),
  //   primaryContainer: Color(0xFFFFBB93),
  //   secondary: Color(0xFF8D6E63),
  //   secondaryContainer: Color(0xFFC19A8B),
  //   background: Color(0xFFF5F5F5),
  //   surface: Colors.white,
  //   error: Color(0xFFE57373),
  //   onPrimary: Colors.white,
  //   onSecondary: Colors.white,
  //   onBackground: Colors.black,
  //   onSurface: Colors.black,
  //   onError: Colors.white,
  // );

  // moderne et lisse
  // ColorScheme colorScheme = const ColorScheme.light(
  //   primary: Color(0xFF2D4C7F),
  //   primaryContainer: Color(0xFFD0DAE9),
  //   secondary: Color(0xFFF4A261),
  //   secondaryContainer: Color(0xFFFFE8D6),
  //   background: Color(0xFFF0F4F8),
  //   surface: Colors.white,
  //   error: Color(0xFFE76F51),
  //   onPrimary: Colors.white,
  //   onSecondary: Colors.black,
  //   onBackground: Colors.black,
  //   onSurface: Colors.black,
  //   onError: Colors.white,
  // );

  TextTheme textTheme = const TextTheme(
    displayLarge: TextStyle(
        fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.black),
    displayMedium: TextStyle(
        fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.black),
    displaySmall: TextStyle(
        fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
    headlineMedium: TextStyle(
        fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
    headlineSmall: TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
    titleLarge: TextStyle(
        fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
    titleMedium: TextStyle(fontSize: 16.0, color: Colors.black),
    titleSmall: TextStyle(fontSize: 14.0, color: Colors.black),
    bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black),
    bodyMedium: TextStyle(fontSize: 14.0, color: Colors.black),
    labelLarge: TextStyle(
        fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
    bodySmall: TextStyle(fontSize: 12.0, color: Colors.black),
    labelSmall: TextStyle(fontSize: 10.0, color: Colors.black),
  );

  return ThemeData(
    colorScheme: colorScheme,
    brightness: Brightness.light,
    textTheme: textTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surface,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(8.0),
      ),
      contentPadding: const EdgeInsets.all(16.0),
    ),
    cardTheme: CardTheme(
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 5,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
