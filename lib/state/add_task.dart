import 'package:diarys/state/hive/controllers/schedule.dart';
import 'package:diarys/state/hive/controllers/tasks.dart';
import 'package:diarys/state/hive/types/task.dart';
import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";

final addTaskController = ChangeNotifierProvider<AddTaskController>((ref) {
  return AddTaskController(ref);
});

class NewTaskData {
  String subject;
  DateTime untilDate;
  int difficulty;
  String content;

  NewTaskData({
    required this.subject,
    required this.difficulty,
    required this.content,
    required this.untilDate,
  });

  Task toTask() {
    return Task(
      subject: subject,
      difficulty: difficulty,
      content: content,
      untilDate: untilDate,
    );
  }

  static NewTaskData empty() {
    return NewTaskData(
      subject: "",
      difficulty: 2, // Default difficulty is 2
      content: "",
      untilDate: DateTime.now().add(
        Duration(days: 1),
      ),
    );
  }
}

class AddTaskController with ChangeNotifier {
  final Ref _ref;
  NewTaskData _data = NewTaskData.empty();

  AddTaskController(this._ref);

  NewTaskData get data => _data;
  bool get readyToCommit {
    return _data.content.isNotEmpty && _data.subject.isNotEmpty;
  }

  void commit() {
    _ref.read(tasksController).add(_data.toTask());
  }

  void setDate(DateTime d) {
    _data.untilDate = d;
    notifyListeners();
  }

  void setNextLessonDate() async {
    final today = DateTime.now().weekday - 1;
    await _ref.read(scheduleController).initBox();
    var days = _ref.read(scheduleController).getDaysContainingLesson(_data.subject);

    days = days.map((e) {
      if (e < today) {
        return 7 - (today - e);
      } else {
        return e - today;
      }
    }).toList();
    days.removeWhere((e) => e == 0);
    days.sort();

    final daysUntillClosesLesson = days.first;
    final nextLesson = DateTime.now().add(Duration(days: daysUntillClosesLesson));
    setDate(nextLesson);
  }

  void setSubject(String s) {
    _data.subject = s;
    notifyListeners();
  }

  void setTask(String t) {
    _data.content = t;
    notifyListeners();
  }

  void setDifficulty(int d) {
    _data.difficulty = d;
    notifyListeners();
  }

  void clear() {
    _data = NewTaskData.empty();
  }
}
