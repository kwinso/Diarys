import 'package:diarys/state/types/day_schedule.dart';
import 'package:diarys/state/types/schedule.dart';
import 'package:diarys/state/types/subjects_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final databaseService = Provider<DatabaseService>((_) => DatabaseService());

class DatabaseService {
  late Box<Schedule> _scheduleBox;
  late Box<SubjectsList> _subjectsBox;

  // Create new instances to avoid updating references to values in boxes
  Schedule get daysSchedule => Schedule(_scheduleBox.values.first.days);
  SubjectsList get subjects => SubjectsList(_subjectsBox.values.first.list);

  Future<void> openScheduleBox() async {
    await Hive.openBox<Schedule>('schedule').then((value) => _scheduleBox = value);

    //first time loading
    if (_scheduleBox.values.isEmpty) {
      final days = List.generate(7, (int idx) => DaySchedule([]));
      _scheduleBox.add(Schedule(days));
    }
  }

  Future<void> openSubjectsBox() async {
    await Hive.openBox<SubjectsList>("subjects").then((value) => _subjectsBox = value);

    if (_subjectsBox.values.isEmpty) {
      _subjectsBox.add(SubjectsList([]));
    }
  }

  Future<void> closeScheduleBox() async => await _scheduleBox.close();

  Future<void> updateSchedule(Schedule s) async => await _scheduleBox.put(0, s);
  Future<void> updateSubjects(SubjectsList s) async {
    await _subjectsBox.put(0, s);
  }
}
