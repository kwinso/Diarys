import 'package:diarys/theme/colors.dart';
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
    const primary = Color(0xFFDFDEDE);
    const bg = Color(0xFFFFFFFF);
    const tertiary = Color(0xFF161515);

    return ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        backgroundColor: bg,
        primaryColor: primary,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: primary,
          primaryContainer: Color.fromARGB(255, 192, 192, 192),
          secondary: AppColors.secondary,
          tertiary: tertiary,
          tertiaryContainer: Color(0xFF9C9C9C),
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
        textSelectionTheme: const TextSelectionThemeData(cursorColor: AppColors.secondary),
        canvasColor: Colors.transparent,
        shadowColor: AppColors.shadow,
        textTheme: const TextTheme(
                bodyText2: TextStyle(color: tertiary), bodyText1: TextStyle(color: tertiary))
            .apply(bodyColor: tertiary, displayColor: tertiary));
  }

  static ThemeData get dark {
    const primary = Color(0xFF35383F);
    const bg = Color(0xFF1E1F25);

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
          secondary: AppColors.secondary,
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
        textSelectionTheme: const TextSelectionThemeData(cursorColor: AppColors.secondary),
        canvasColor: Colors.transparent,
        shadowColor: AppColors.shadow,
        textTheme: const TextTheme(
                bodyText2: TextStyle(color: Colors.white),
                bodyText1: TextStyle(color: Colors.white))
            .apply(bodyColor: Colors.white, displayColor: Colors.white));
  }
}
