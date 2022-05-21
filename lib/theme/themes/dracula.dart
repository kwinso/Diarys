import 'package:diarys/theme/colors.dart';
import 'package:diarys/theme/themes/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _primary = Color.fromARGB(255, 59, 62, 82);
const _primaryContainer = Color(0xFFBFBFBF);
const _bg = Color(0xFF282A36);
const _tertiary = Colors.white;

final DraculaTheme = AppThemeData(
  "Dracula",
  ThemeData(
    brightness: Brightness.dark,
    splashColor: const Color(0x00ECE9E9),
    highlightColor: Colors.transparent,
    focusColor: Colors.transparent,
    backgroundColor: _bg,
    scaffoldBackgroundColor: _bg,
    primaryColor: _primary,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        systemStatusBarContrastEnforced: false,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: _primary,
      primaryContainer: _primaryContainer,
      secondary: AppColors.secondary,
      tertiary: _tertiary,
      tertiaryContainer: Color(0xFF7284BB),
      background: _bg,
      onSecondary: _tertiary,
      onPrimaryContainer: _tertiary,
      onPrimary: _tertiary,
      error: AppColors.red,
      onError: _tertiary,
      onBackground: _tertiary,
      surface: _primary,
      onSurface: _tertiary,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(color: _tertiary),
    ),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: AppColors.secondary),
    canvasColor: Colors.transparent,
    shadowColor: const Color(0x2E6B6B6B),
    textTheme: const TextTheme(
            bodyText2: TextStyle(color: _tertiary), bodyText1: TextStyle(color: _tertiary))
        .apply(bodyColor: _tertiary, displayColor: _tertiary),
  ),
);
