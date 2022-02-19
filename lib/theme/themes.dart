import "package:flutter/material.dart";

AppThemeData currentTheme = AppThemeData();

class AppThemeData with ChangeNotifier {
  static bool _isDark = true;
  ThemeMode get mode => _isDark ? ThemeMode.dark : ThemeMode.light;

  void toggle() {
    _isDark = !_isDark;
    notifyListeners();
  }

  static ThemeData get light {
    const Color primary = Color.fromARGB(255, 223, 222, 222);
    const Color bg = Color(0xFFFFFFFF);
    const Color tertiary = Color(0xFF6D6A6A);

    return ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        backgroundColor: bg,
        primaryColor: primary,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: primary,
          primaryContainer: Color.fromARGB(255, 155, 155, 155),
          secondary: Color(0xFF9556D3),
          tertiary: tertiary,
          tertiaryContainer: Color(0xFF797979),
          background: bg,
          onSecondary: Colors.white,
          onPrimaryContainer: Colors.white,
          onTertiary: Colors.white,
          onPrimary: tertiary,
          error: Color(0xFFFB4343),
          onError: Colors.white,
          onBackground: tertiary,
          surface: primary,
          onSurface: tertiary,
        ),
        textTheme: const TextTheme(
                bodyText2: TextStyle(color: tertiary), bodyText1: TextStyle(color: tertiary))
            .apply(bodyColor: tertiary, displayColor: tertiary));
  }

  static ThemeData get dark {
    const Color primary = Color(0xFF35383F);
    const Color bg = Color(0xFF1E1F25);

    return ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        backgroundColor: bg,
        primaryColor: primary,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: primary,
          primaryContainer: Color(0xFF5C5F64),
          secondary: Color(0xFF9556D3),
          tertiary: Colors.white,
          tertiaryContainer: Color(0xFFA1A19F),
          background: bg,
          onSecondary: Colors.white,
          onPrimaryContainer: Colors.white,
          onPrimary: Colors.white,
          error: Color(0xFFFB4343),
          onError: Colors.white,
          onBackground: Colors.white,
          surface: primary,
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFF282B30),
        textTheme: const TextTheme(
                bodyText2: TextStyle(color: Colors.white),
                bodyText1: TextStyle(color: Colors.white))
            .apply(bodyColor: Colors.white, displayColor: Colors.white));
  }
}
