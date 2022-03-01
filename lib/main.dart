import 'package:diarys/app.dart';
import 'package:diarys/state/db_service.dart';
import 'package:diarys/state/hive_types/day_schedule.dart';
import 'package:diarys/state/hive_types/schedule.dart';
import 'package:diarys/state/hive_types/subject.dart';
import 'package:diarys/state/hive_types/subjects_list.dart';
import 'package:flutter/material.dart';
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
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  // // TODO: Delete
  // Hive.deleteBoxFromDisk("subjects");
  final db = DatabaseService();
  await db.openSubjectsBox();

  runApp(ProviderScope(overrides: [databaseService.overrideWithValue(db)], child: const App()));
}
