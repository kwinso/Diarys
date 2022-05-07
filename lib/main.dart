import 'package:diarys/app.dart';
import 'package:diarys/state/hive/controllers/subjects.dart';
import 'package:diarys/state/hive/types/day_schedule.dart';
import 'package:diarys/state/hive/types/schedule.dart';
import 'package:diarys/state/hive/types/subject.dart';
import 'package:diarys/state/hive/types/subjects_list.dart';
import 'package:diarys/state/hive/types/task.dart';
import 'package:diarys/state/hive/types/tasks_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:hive_flutter/hive_flutter.dart";
import 'package:path_provider/path_provider.dart';

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
  await subjects.initBox();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white, // navigation bar color
    statusBarColor: Colors.white, // status bar color
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(ProviderScope(
      overrides: [subjectsController.overrideWithValue(subjects)], child: const App()));
}
