import 'package:diarys/theme/colors.dart';
import 'package:diarys/theme/themes/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _primary = Color(0xFF18181a);
const _primaryContainer = Color.fromARGB(255, 139, 139, 139);
const _bg = Color(0xFF101011);
const _tertiary = Color(0xFFE7E9EE);
const _secondary = Color(0xFFEE3636);

final MindallTheme = AppThemeData(
  "Миндальная",
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
        systemNavigationBarColor: _primary,
        systemNavigationBarContrastEnforced: false,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: _primary,
      primaryContainer: _primaryContainer,
      secondary: _secondary,
      tertiary: _tertiary,
      tertiaryContainer: Color.fromARGB(255, 98, 99, 102),
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
    snackBarTheme:
        SnackBarThemeData(actionTextColor: _secondary, elevation: 10, backgroundColor: _primary),
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
