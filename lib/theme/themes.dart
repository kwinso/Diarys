import 'package:diarys/theme/colors.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";

final themeController = ChangeNotifierProvider<AppTheme>((ref) {
  return AppTheme();
});

class AppTheme with ChangeNotifier {
  static bool _isDark = false;
  ThemeMode get mode => _isDark ? ThemeMode.dark : ThemeMode.light;
  ThemeData get current => _isDark ? dark : light;

  void toggle({bool? value}) {
    _isDark = value ?? !_isDark;

    // System navigation bar color cannot be affect with ThemeData, so change in here
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: current.primaryColor,
    ));

    notifyListeners();
  }

  static ThemeData get light {
    const bg = Color(0xFFEFF1F6);
    const primary = Color(0xFFFFFFFF);
    const primaryContainer = Color.fromARGB(255, 201, 201, 201);
    const tertiary = Color(0xFF343434);

    return ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        backgroundColor: bg,
        scaffoldBackgroundColor: bg,
        primaryColor: primary,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            systemStatusBarContrastEnforced: false,
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
          ),
        ),
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: primary,
          primaryContainer: primaryContainer,
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
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(color: tertiary),
        ),
        textSelectionTheme: const TextSelectionThemeData(cursorColor: AppColors.secondary),
        canvasColor: Colors.transparent,
        shadowColor: const Color(0x3E7A7A7A),
        textTheme: const TextTheme(
          bodyText2: TextStyle(),
          bodyText1: TextStyle(),
        ).apply(bodyColor: tertiary, displayColor: tertiary));
  }

  static ThemeData get dark {
    const primary = Color(0xFF2C2B2B);
    const primaryContainer = Color(0xFF7E7E7E);
    const bg = Color(0xFF252525);
    const tertiary = Colors.white;

    return ThemeData(
        brightness: Brightness.dark,
        splashColor: const Color(0x00ECE9E9),
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        backgroundColor: bg,
        scaffoldBackgroundColor: bg,
        primaryColor: primary,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            systemStatusBarContrastEnforced: false,
            statusBarIconBrightness: Brightness.light,
            statusBarColor: Colors.transparent,
          ),
        ),
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: primary,
          primaryContainer: primaryContainer,
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
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(color: tertiary),
        ),
        textSelectionTheme: const TextSelectionThemeData(cursorColor: AppColors.secondary),
        canvasColor: Colors.transparent,
        shadowColor: const Color(0x2E6B6B6B),
        textTheme: const TextTheme(
                bodyText2: TextStyle(color: tertiary), bodyText1: TextStyle(color: tertiary))
            .apply(bodyColor: tertiary, displayColor: tertiary));
  }
}
