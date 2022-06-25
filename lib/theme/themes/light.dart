import 'package:diarys/theme/colors.dart';
import 'package:diarys/theme/themes/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _bg = Color(0xFFEFF1F6);
const _primary = Color(0xFFFFFFFF);
const _primaryContainer = Color.fromARGB(255, 201, 201, 201);
const _tertiary = Color(0xFF343434);

final LightTheme = AppThemeData(
    "Светлая",
    ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      backgroundColor: _bg,
      scaffoldBackgroundColor: _bg,
      primaryColor: _primary,
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          systemStatusBarContrastEnforced: false,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
      ),
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: _primary,
        primaryContainer: _primaryContainer,
        secondary: AppColors.secondary,
        tertiary: _tertiary,
        tertiaryContainer: Color(0xFF676E83),
        background: _bg,
        onSecondary: Colors.white,
        onPrimaryContainer: Colors.white,
        onTertiary: Colors.white,
        onPrimary: _tertiary,
        error: AppColors.red,
        onError: Colors.white,
        onBackground: _tertiary,
        surface: _primary,
        onSurface: _tertiary,
      ),
      snackBarTheme: SnackBarThemeData(
        actionTextColor: AppColors.secondary,
        elevation: 10,
        backgroundColor: _primary,
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
      shadowColor: const Color(0x3E7A7A7A),
      textTheme: const TextTheme(
        bodyText2: TextStyle(),
        bodyText1: TextStyle(),
      ).apply(bodyColor: _tertiary, displayColor: _tertiary),
    ));
