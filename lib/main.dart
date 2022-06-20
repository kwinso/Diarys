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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  final subjects = SubjectsController();
  await subjects.subscribe();

  final theme = AppThemeController();
  final smartScreens = SmartScreensSettingsController();

  runApp(
    ProviderScope(
      overrides: [
        subjectsController.overrideWithValue(subjects),
        themeController.overrideWithValue(theme),
        smartScreensController.overrideWithValue(smartScreens)
      ],
      child: App(
          // startScreen: smartScreenInfo[0],
          // openAddScreen: smartScreenInfo[1],
          ),
    ),
  );
}
