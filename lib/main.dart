import 'package:diarys/app.dart';
import 'package:diarys/state/hive/controllers/subjects.dart';
import 'package:diarys/state/hive/types/day_schedule.dart';
import 'package:diarys/state/hive/types/schedule.dart';
import 'package:diarys/state/hive/types/subject.dart';
import 'package:diarys/state/hive/types/subjects_list.dart';
import 'package:diarys/state/hive/types/task.dart';
import 'package:diarys/state/hive/types/tasks_list.dart';
import 'package:diarys/state/smart_screens.dart';
import 'package:diarys/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:hive_flutter/hive_flutter.dart";
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initHive() async {
  final appDir = await getApplicationDocumentsDirectory();
  Hive.init(appDir.path);
  Hive.registerAdapter(ScheduleAdapter());
  Hive.registerAdapter(DayScheduleAdapter());
  Hive.registerAdapter(SubjectsListAdapter());
  Hive.registerAdapter(SubjectAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(TasksListAdapter());
}

List getSmartScreensInfo(SmartScreensSettingsController smartScreens) {
  if (smartScreens.enabled) {
    final now = TimeOfDay.now();
    final schoolStart = smartScreens.schoolStart;
    final schoolEnd = smartScreens.schoolEnd;

    var afterStart = false;
    if (now.hour > schoolStart.hour)
      afterStart = true;
    else if (now.hour == schoolStart.hour && now.minute >= schoolStart.minute) afterStart = true;

    var beforeEnd = false;
    if (now.hour < schoolEnd.hour)
      beforeEnd = true;
    else if (now.hour == schoolEnd.hour && now.minute < schoolEnd.minute) beforeEnd = true;

    final isInSchool = afterStart && beforeEnd;
    final activeScreen = isInSchool ? smartScreens.schoolScreen : smartScreens.homeScreen;

    final openAddScreen = smartScreens.addInSchool && isInSchool;
    return [activeScreen, openAddScreen];
  }

  return [0, false];
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  final subjects = SubjectsController();
  await subjects.subscribe();

  final prefs = await SharedPreferences.getInstance();
  final theme = AppThemeController(prefs.getInt("theme"));
  final smartScreens = SmartScreensSettingsController(prefs);
  final smartScreenInfo = getSmartScreensInfo(smartScreens);

  runApp(
    ProviderScope(
      overrides: [
        subjectsController.overrideWithValue(subjects),
        themeController.overrideWithValue(theme),
        smartScreensController.overrideWithValue(smartScreens)
      ],
      child: App(
        startScreen: smartScreenInfo[0],
        openAddScreen: smartScreenInfo[1],
      ),
    ),
  );
}
