import 'package:diarys/theme/colors.dart';
import 'package:diarys/theme/themes/dark.dart';
import 'package:diarys/theme/themes/dracula.dart';
import 'package:diarys/theme/themes/light.dart';
import 'package:diarys/theme/themes/app_theme_data.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";

final themeController = ChangeNotifierProvider<AppThemeController>((ref) {
  return AppThemeController();
});

class AppThemeController with ChangeNotifier {
  static List<AppThemeData> themes = [
    LightTheme,
    DarkTheme,
    DraculaTheme,
  ];
  int _currentThemeIndex = 2;
  ThemeData get current => themes[_currentThemeIndex].data;
  int get currentInt => _currentThemeIndex;

  void setTheme(int index) {
    _currentThemeIndex = index;

    // System navigation bar color cannot be affect with ThemeData, so change in here
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: current.primaryColor,
    ));

    notifyListeners();
  }
}
