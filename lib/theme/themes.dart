import 'package:diarys/theme/colors.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';

final appTheme = AppThemeData();

class AppThemeData with ChangeNotifier {
  static bool _isDark = false;
  ThemeMode get mode => _isDark ? ThemeMode.dark : ThemeMode.light;
  // ThemeData get data => _isDark ? dark : light;

  void toggle({bool? value}) {
    _isDark = value ?? !_isDark;
    notifyListeners();
  }

  static ThemeData get light {
    const bg = Color(0xFFEFF1F6);
    const primary = Color(0xFFFFFFFF);
    const tertiary = Color(0xFF343434);

    return ThemeData(
        brightness: Brightness.light,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        backgroundColor: bg,
        primaryColor: primary,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: primary,
            systemNavigationBarColor: primary,
          ),
        ),
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: primary,
          primaryContainer: Color(0xFFBFBFBF),
          secondary: AppColors.secondary,
          tertiary: tertiary,
          tertiaryContainer: Color(0xFF676E83),
          background: bg,
          onSecondary: Colors.white,
          onPrimaryContainer: Colors.white,
          onTertiary: Colors.white,
          onPrimary: tertiary,
          error: AppColors.red,
          onError: Colors.white,
          onBackground: tertiary,
          surface: primary,
          onSurface: tertiary,
        ),
        textSelectionTheme: const TextSelectionThemeData(cursorColor: AppColors.secondary),
        canvasColor: Colors.transparent,
        shadowColor: const Color.fromRGBO(122, 122, 122, 0.25),
        textTheme: const TextTheme(
          bodyText2: TextStyle(),
          bodyText1: TextStyle(),
        ).apply(bodyColor: tertiary, displayColor: tertiary));
  }

  static ThemeData get dark {
    //  TODO: Change primary to this: 0xFF35383F
    const primary = Color(0xFF2C2B2B);
    const bg = Color.fromARGB(255, 37, 37, 37);
    const tertiary = Colors.white;

    return ThemeData(
        brightness: Brightness.dark,
        splashColor: Color.fromARGB(0, 236, 233, 233),
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        backgroundColor: bg,
        primaryColor: primary,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: primary,
            systemNavigationBarColor: primary,
          ),
        ),
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: primary,
          primaryContainer: Color(0xFF7E7E7E),
          secondary: AppColors.secondary,
          tertiary: tertiary,
          tertiaryContainer: Color(0xFF828690),
          background: bg,
          onSecondary: tertiary,
          onPrimaryContainer: tertiary,
          onPrimary: tertiary,
          error: AppColors.red,
          onError: tertiary,
          onBackground: tertiary,
          surface: primary,
          onSurface: tertiary,
        ),
        textSelectionTheme: const TextSelectionThemeData(cursorColor: AppColors.secondary),
        canvasColor: Colors.transparent,
        shadowColor: Color.fromARGB(62, 107, 107, 107),
        textTheme: const TextTheme(
                bodyText2: TextStyle(color: tertiary), bodyText1: TextStyle(color: tertiary))
            .apply(bodyColor: tertiary, displayColor: tertiary));
  }
}
