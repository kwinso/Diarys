import 'package:diarys/state/types/day_schedule.dart';
import 'package:diarys/state/types/schedule.dart';
import 'package:diarys/state/types/subject.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final databaseService = Provider<DatabaseService>((_) => DatabaseService());

class DatabaseService {
  late Box<Schedule> _scheduleBox;
  late Box<List<Subject>> _lessonsListBox;

  // Create new instances to avoid updating references to values in boxes
  Schedule get daysSchedule => Schedule(_scheduleBox.values.first.days);
  List<Subject> get lessons => List<Subject>.from(_lessonsListBox.values.first);

  Future<void> openScheduleBox() async {
    await Hive.openBox<Schedule>('schedule').then((value) => _scheduleBox = value);

    //first time loading
    if (_scheduleBox.values.isEmpty) {
      final days = List.generate(7, (int idx) => DaySchedule([]));
      _scheduleBox.add(Schedule(days));
    }
  }

  Future<void> openSubjectsBox() async {
    await Hive.openBox<List<Subject>>("subjects").then((value) => _lessonsListBox = value);

    if (_lessonsListBox.isEmpty) {
      _lessonsListBox.add(<Subject>[]);
    }
  }

  Future<void> closeScheduleBox() async => await _scheduleBox.close();

  Future<void> updateSchedule(Schedule s) async => await _scheduleBox.put(0, s);
  Future<void> updateSubjects(List<Subject> s) async {
    print(s);
    await _lessonsListBox.put(0, s);
  }
}
