import 'package:flutter/material.dart';

class ThemeColorSchemeProvider with ChangeNotifier {
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
        error: Color(0xFFE76F51),
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onBackground: Colors.black,
        onSurface: Colors.black,
        onError: Colors.white,
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
  List<String> get availableThemes => _themes.map((t) => t.name).toList();

  void setColorScheme(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}

class CustomColorScheme {
  final String name;
  final ColorScheme colorScheme;

  CustomColorScheme({required this.name, required this.colorScheme});
}
