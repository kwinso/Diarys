import 'package:diarys/state/types/day_schedule.dart';
import 'package:diarys/state/types/schedule.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final databaseService = Provider<DatabaseService>((_) => DatabaseService());

class DatabaseService {
  late Box<Schedule> _scheduleBox;
  late Box<List<String>> _lessonsListBox;

  Schedule get daysSchedule => _scheduleBox.values.first;
  List<String> get lessons => _lessonsListBox.values.first;

  Future<void> openScheduleBox() async {
    await Hive.openBox<Schedule>('schedule').then((value) => _scheduleBox = value);

    //first time loading
    if (_scheduleBox.values.isEmpty) {
      final days = List.generate(7, (int idx) => DaySchedule([]));
      _scheduleBox.add(Schedule(days));
    }
  }

  Future<void> openLessonsBox() async {
    await Hive.openBox<List<String>>("lessons_list").then((value) => _lessonsListBox = value);

    if (_lessonsListBox.isEmpty) {
      _lessonsListBox.add([]);
    }
  }

  Future<void> closeScheduleBox() async => await _scheduleBox.close();
  Future<void> closeLessonsBox() async => await _lessonsListBox.close();

  Future<void> updateSchedule(Schedule s) async => await _scheduleBox.put(0, s);
  Future<void> updateLessons(List<String> s) async => await _lessonsListBox.put(0, s);
}
