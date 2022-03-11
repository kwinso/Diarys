import 'package:diarys/state/hive_types/day_schedule.dart';
import 'package:diarys/state/hive_types/schedule.dart';
import 'package:diarys/state/hive_types/subjects_list.dart';
import 'package:diarys/state/hive_types/task.dart';
import 'package:diarys/state/hive_types/tasks_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final databaseService = Provider<DatabaseService>((_) => DatabaseService());

typedef TypeCreator<T> = T Function(T value);

class BoxController<T> {
  final TypeCreator<T> _instanceCreator;
  final String _name;
  late Box<T> _box;

  BoxController(this._name, this._instanceCreator);

  /// A copy of value in box
  get value => _instanceCreator(_box.values.first);

  /// [fill] runs if opened box is empty
  Future<void> open(Function(Box<T> box) fill) async {
    await Hive.openBox<T>(_name).then((v) => _box = v);
    if (_box.values.isEmpty) fill(_box);
  }

  /// Updates first box value to [v]
  Future<void> updateValue(T v) async => await _box.put(0, v);

  /// Closes the box
  Future<void> close() async => await _box.close();
}

class DatabaseService {
  late BoxController<Schedule> _scheduleBox;
  late BoxController<SubjectsList> _subjectsBox;
  late BoxController<TasksList> _tasksBox;

  BoxController<Schedule> get scheduleBox => _scheduleBox;
  BoxController<SubjectsList> get subjectsBox => _subjectsBox;
  BoxController<TasksList> get tasksBox => _tasksBox;

  Future<void> openSchedule() async {
    _scheduleBox = BoxController<Schedule>("schedule", (value) => Schedule(value.days));
    await scheduleBox.open((box) {
      final days = List.generate(7, (int idx) => DaySchedule([]));
      box.add(Schedule(days));
    });
  }

  Future<void> openTasks() async {
    _tasksBox = BoxController<TasksList>(
        "tasks", (value) => TasksList(all: value.all, recomendations: value.recomendations));
    await tasksBox.open((box) {
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
      box.add(TasksList(
        all: dummy,
        recomendations: dummy,
      ));
    });
  }

  Future<void> openSubjects() async {
    _subjectsBox = BoxController<SubjectsList>("subjects", (value) => SubjectsList(value.list));
    await subjectsBox.open((box) {
      box.add(SubjectsList([]));
    });
  }
}
