// theme_color_scheme_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:k_sport_front/helpers/logger.dart';
import 'package:k_sport_front/services/api.dart';

class ThemeColorSchemeProvider with ChangeNotifier {
  static final String baseUrl = dotenv.env['API_URL'] ??
      'http://10.0.2.2:3000'; // Default URL if .env is not loaded

  TextTheme _getTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      displayLarge: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          color: colorScheme.onBackground),
      displayMedium: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
          color: colorScheme.onBackground),
      displaySmall: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: colorScheme.onBackground),
      headlineMedium: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: colorScheme.onBackground),
      headlineSmall: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: colorScheme.onBackground),
      titleLarge: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: colorScheme.onBackground),
      titleMedium: TextStyle(fontSize: 16.0, color: colorScheme.onBackground),
      titleSmall: TextStyle(fontSize: 14.0, color: colorScheme.onBackground),
      bodyLarge: TextStyle(fontSize: 16.0, color: colorScheme.onBackground),
      bodyMedium: TextStyle(fontSize: 14.0, color: colorScheme.onBackground),
      labelLarge: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: colorScheme.onBackground),
      bodySmall: TextStyle(fontSize: 12.0, color: colorScheme.onBackground),
      labelSmall: TextStyle(fontSize: 10.0, color: colorScheme.onBackground),
    );
  }

  final List<CustomColorScheme> _themes = [
    CustomColorScheme(
      name: "Moderne et Lisse",
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF2D4C7F),
        primaryContainer: Color(0xFFD0DAE9),
        secondary: Color(0xFFF4A261),
        secondaryContainer: Color(0xFFFFE8D6),
        background: Color(0xFFF0F4F8),
        surface: Colors.white,
        error: Color(0xFFE74C3C),
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onBackground: Colors.black,
        onSurface: Colors.black,
        onError: Colors.white,
      ),
    ),
    CustomColorScheme(
      name: "Sombre bleu gris",
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF2C3E50),
        primaryContainer: Color(0xFF34495E),
        secondary: Color(0xFF2C3E50),
        secondaryContainer: Color(0xFF34495E),
        background: Color(0xFF1C1C1C),
        surface: Color(0xFF2C2C2C),
        error: Color(0xFFE74C3C),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Colors.white,
        onSurface: Colors.white,
        onError: Colors.black,
      ),
    ),
    CustomColorScheme(
      name: "Bleu",
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF0056D2),
        primaryContainer: Color(0xFFD6E4FF),
        secondary: Color(0xFF007BFF),
        secondaryContainer: Color(0xFFCCE0FF),
        background: Color(0xFFF3F4F6),
        surface: Colors.white,
        error: Colors.redAccent,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Colors.black,
        onSurface: Colors.black,
        onError: Colors.white,
      ),
    ),
    CustomColorScheme(
      name: "Orange et Marron",
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFFF8A65),
        primaryContainer: Color(0xFFFFBB93),
        secondary: Color(0xFF8D6E63),
        secondaryContainer: Color(0xFFC19A8B),
        background: Color(0xFFF5F5F5),
        surface: Colors.white,
        error: Color(0xFFE57373),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Colors.black,
        onSurface: Colors.black,
        onError: Colors.white,
      ),
    ),
  ];

  int _currentIndex = 0;

  ColorScheme get colorScheme => _themes[_currentIndex].colorScheme;
  String get currentThemeName => _themes[_currentIndex].name;
  TextTheme get textTheme => _getTextTheme(colorScheme);
  List<String> get availableThemes => _themes.map((t) => t.name).toList();

  void setColorScheme(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Future<void> updateTheme(String themeName) async {
    final index = _themes.indexWhere((t) => t.name == themeName);
    if (index != -1) {
      _currentIndex = index;
      notifyListeners();

      final response = await Api().patch(
        '$baseUrl/user/updateTheme',
        {'theme': themeName},
      );

      if (response.statusCode != 200) {
        // Handle error
      }
    }
  }

  void setThemeByName(String themeName) {
    final index = _themes.indexWhere((t) => t.name == themeName);
    Log.logger.i("setThemeByName: $themeName\n index: $index");
    if (index != -1) {
      _currentIndex = index;
      notifyListeners();
    } else {
      Log.logger.e(themeName);
      // Optionally handle the case where the themeName is not found
    }
  }
}

class CustomColorScheme {
  final String name;
  final ColorScheme colorScheme;

  CustomColorScheme({required this.name, required this.colorScheme});
}
