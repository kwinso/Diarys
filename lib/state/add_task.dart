import 'package:diarys/state/hive/controllers/schedule.dart';
import 'package:diarys/state/hive/controllers/subjects.dart';
import 'package:diarys/state/hive/controllers/tasks.dart';
import 'package:diarys/state/hive/types/task.dart';
import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:table_calendar/table_calendar.dart';

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
        const Duration(days: 1),
      ),
    );
  }
}

class AddTaskController with ChangeNotifier {
  final Ref _ref;
  NewTaskData _data = NewTaskData.empty();
  bool _saveToSchedule = true;

  AddTaskController(this._ref);

  NewTaskData get data => _data;
  bool get saveToSchedule => _saveToSchedule;

  set saveToSchedule(v) {
    _saveToSchedule = v;
    notifyListeners();
  }

  bool get readyToCommit {
    return _data.content.isNotEmpty && _data.subject.isNotEmpty;
  }

  bool get subjectInSchedule =>
      _ref.read(scheduleController).dayContains(_data.untilDate.weekday - 1, _data.subject);

  Future<void> commit() async {
    if (_saveToSchedule && !subjectInSchedule) {
      final schedule = _ref.read(scheduleController);
      // Add subject to day the task is assigned to:
      // If user wants to add to some day, it probably means there's a lesson for a gived subject
      // On that day
      final until = _data.untilDate;
      await schedule.addLessonsToDay(until.weekday - 1, [_data.subject], allowDuplicate: false);
      // TODO: Run if setting to "add to current day too is enabled"
      // final today = DateTime.now();
      // if (!isSameDay(today, until)) {
      //   await schedule.addLessonsToDay(today.weekday - 1, [_data.subject], allowDuplicate: false);
      // }
    }
    _ref.read(tasksController).add(_data.toTask());

    reset();
  }

  void reset() {
    _data = NewTaskData.empty();
    _saveToSchedule = true;
  }

  // Listeners for this one are not notified because the only place where untilDate is used
  // will be aware of change when date is changed
  void setDate(DateTime d) {
    _data.untilDate = d;
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

  void setContent(String t) {
    _data.content = t;
    notifyListeners();
  }

  void setDifficulty(int d) {
    _data.difficulty = d;
    notifyListeners();
  }
}
