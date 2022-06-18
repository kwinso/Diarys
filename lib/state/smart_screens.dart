import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final smartScreensController = ChangeNotifierProvider<SmartScreensSettingsController>((ref) {
  return SmartScreensSettingsController(null);
});

const String _prefix = "smart_screens";

class SmartScreensSettingsController with ChangeNotifier {
  final SharedPreferences? _prefs;

  SmartScreensSettingsController(this._prefs);

  // Future<void> init() async {
  //   _prefs ??= await SharedPreferences.getInstance();
  // }

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

  int get homeScreen {
    return _prefs?.getInt("$_prefix:home_screen") ?? 1;
  }

  set homeScreen(int v) {
    _prefs?.setInt("$_prefix:home_screen", v);
    notifyListeners();
  }

  bool get addInSchool {
    return _prefs?.getBool("$_prefix:add_in_school") ?? false;
  }

  set addInSchool(v) {
    _prefs?.setBool("$_prefix:add_in_school", v);
    notifyListeners();
  }

  TimeOfDay _stringToTimeOfDay(String str) {
    final split = str.split(":");
    final hour = int.parse(split[0]);
    final minute = int.parse(split[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  TimeOfDay get schoolStart {
    final saved = _prefs?.getString("$_prefix:school_start");
    return saved != null ? _stringToTimeOfDay(saved) : const TimeOfDay(hour: 8, minute: 0);
  }

  set schoolStart(TimeOfDay v) {
    _prefs?.setString("$_prefix:school_start", "${v.hour}:${v.minute}");
    notifyListeners();
  }

  TimeOfDay get schoolEnd {
    final saved = _prefs?.getString("$_prefix:school_end");
    return saved != null ? _stringToTimeOfDay(saved) : const TimeOfDay(hour: 14, minute: 0);
  }

  set schoolEnd(TimeOfDay v) {
    _prefs?.setString("$_prefix:school_end", "${v.hour}:${v.minute}");
    notifyListeners();
  }
}
