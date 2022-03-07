import 'package:diarys/state/hive_types/day_schedule.dart';
import 'package:diarys/state/hive_types/schedule.dart';
import 'package:diarys/state/hive_types/subjects_list.dart';
import 'package:diarys/state/hive_types/task.dart';
import 'package:diarys/state/hive_types/tasks_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final databaseService = Provider<DatabaseService>((_) => DatabaseService());

class DatabaseService {
  late Box<Schedule> _scheduleBox;
  late Box<SubjectsList> _subjectsBox;
  late Box<TasksList> _tasksBox;

  // Create new instances to avoid updating references to values in boxes
  Schedule get daysSchedule => Schedule(_scheduleBox.values.first.days);
  SubjectsList get subjects => SubjectsList(_subjectsBox.values.first.list);
  TasksList get tasks {
    final t = _tasksBox.values.first;
    return TasksList(all: t.all, recomendations: t.recomendations);
  }

  Future<void> openScheduleBox() async {
    await Hive.openBox<Schedule>('schedule').then((value) => _scheduleBox = value);

    if (_scheduleBox.values.isEmpty) {
      final days = List.generate(7, (int idx) => DaySchedule([]));
      _scheduleBox.add(Schedule(days));
    }
  }

  Future<void> openTasksBox() async {
    await Hive.openBox<TasksList>('tasks').then((value) => _tasksBox = value);

    if (_tasksBox.values.isEmpty) {
      // TODO: remove
      final now = DateTime.now();
      final dummy = List.generate(
        3,
        (index) => Task(
          subject: "Алгебра",
          difficulty: index + 1,
          textContent: "Какая-то длинная домашка глупая математичка блин",
          untilDate: DateTime(now.year, now.month, now.day + 1),
        ),
      );
      _tasksBox.add(TasksList(
        all: dummy,
        recomendations: dummy,
      ));
    }
  }

  Future<void> openSubjectsBox() async {
    await Hive.openBox<SubjectsList>("subjects").then((value) => _subjectsBox = value);

    if (_subjectsBox.values.isEmpty) {
      _subjectsBox.add(SubjectsList([]));
    }
  }

  Future<void> closeScheduleBox() async => await _scheduleBox.close();
  Future<void> closeTasksBox() async => await _tasksBox.close();

  Future<void> updateSchedule(Schedule s) async => await _scheduleBox.put(0, s);
  Future<void> updateSubjects(SubjectsList s) async {
    await _subjectsBox.put(0, s);
  }
}
