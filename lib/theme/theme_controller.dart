import 'package:diarys/theme/colors.dart';
import 'package:diarys/theme/themes/dark.dart';
import 'package:diarys/theme/themes/dracula.dart';
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
    DraculaTheme,
  ];
  int _currentThemeIndex = 0; // The default theme is Dark

  AppThemeController(int? defaultTheme) {
    _currentThemeIndex = defaultTheme ?? 0;
  }

  ThemeData get current => themes[_currentThemeIndex].data;
  int get currentInt => _currentThemeIndex;

  void setTheme(int index) async {
    _currentThemeIndex = index;

    // System navigation bar color cannot be affect with ThemeData, so change in here
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: current.primaryColor,
    ));

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("theme", index);

    notifyListeners();
  }
}
