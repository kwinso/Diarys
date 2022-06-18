import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final smartScreensController = ChangeNotifierProvider<SmartScreensSettingsController>((ref) {
  return SmartScreensSettingsController();
});

const String _prefix = "smart_screens";

class SmartScreensSettingsController with ChangeNotifier {
  SharedPreferences? _prefs;

  SmartScreensSettingsController() {
    _getPrefs();
  }

  Future<void> _getPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get enabled {
    return _prefs?.getBool("$_prefix:enabled") ?? false;
  }

  set enabled(bool v) {
    _prefs?.setBool("$_prefix:enabled", v);
    notifyListeners();
  }

  int get schoolScreen {
    return _prefs?.getInt("$_prefix:school_screen") ?? 0;
  }

  set schoolScreen(int v) {
    _prefs?.setInt("$_prefix:school_screen", v);
    notifyListeners();
  }

  int? _homeScreen;
  int get homeScreen {
    return _prefs?.getInt("$_prefix:home_screen") ?? 0;
  }

  set homeScreen(int v) {
    _homeScreen = v;
    _prefs?.setInt("$_prefix:home_screen", v);
    notifyListeners();
  }

  bool? _addInSchool;
  bool get addInSchool {
    if (_addInSchool == null) {
      final saved = _prefs?.getBool("$_prefix:add_in_school");
      if (saved != null)
        _addInSchool = saved;
      else
        addInSchool = false;
    }
    return _addInSchool!;
  }

  set addInSchool(v) {
    _addInSchool = v;
    _prefs?.setBool("$_prefix:add_in_school", v);
    notifyListeners();
  }

  TimeOfDay _stringToTimeOfDay(String str) {
    final split = str.split(":");
    final hour = int.parse(split[0]);
    final minute = int.parse(split[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  TimeOfDay get inSchoolTime {
    final saved = _prefs?.getString("$_prefix:in_school");
    return saved != null ? _stringToTimeOfDay(saved) : const TimeOfDay(hour: 14, minute: 0);
  }

  set inSchoolTime(TimeOfDay v) {
    _prefs?.setString("$_prefix:in_school", "${v.hour}:${v.minute}");
    notifyListeners();
  }

  TimeOfDay get atHomeTime {
    final saved = _prefs?.getString("$_prefix:at_home");
    return saved != null ? _stringToTimeOfDay(saved) : const TimeOfDay(hour: 14, minute: 0);
  }

  set atHomeTime(TimeOfDay v) {
    _prefs?.setString("$_prefix:at_home", "${v.hour}:${v.minute}");
    notifyListeners();
  }
}
