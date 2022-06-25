import 'dart:async';
import 'package:diarys/theme/themes/dark.dart';
import 'package:diarys/theme/themes/mindall.dart';
import 'package:diarys/theme/themes/light.dart';
import 'package:diarys/theme/themes/app_theme_data.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:shared_preferences/shared_preferences.dart';

final themeController = ChangeNotifierProvider<AppThemeController>((ref) {
  return AppThemeController(null);
});

class AppThemeController with ChangeNotifier {
  static List<AppThemeData> themes = [
    DarkTheme,
    LightTheme,
    MindallTheme,
  ];
  int _currentThemeIndex = 0; // The default theme is Dark

  AppThemeController(int? defaultTheme) {
    setTheme(defaultTheme ?? 0);
  }

  ThemeData get current => themes[_currentThemeIndex].data;
  int get currentInt => _currentThemeIndex;

  void setTheme(int index) async {
    _currentThemeIndex = index;

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("theme", index);

    notifyListeners();

    Timer(Duration(milliseconds: 250), () {
      // System navigation bar color cannot be affected with ThemeData, so change it here
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          systemNavigationBarColor: current.primaryColor,
          systemNavigationBarContrastEnforced: true,
          systemNavigationBarIconBrightness:
              current.brightness == Brightness.dark ? Brightness.light : Brightness.dark,
        ),
      );
    });
  }
}
