import 'package:diarys/state/hive/controllers/schedule.dart';
import 'package:diarys/state/hive/controllers/subjects.dart';
import 'package:diarys/state/hive/controllers/tasks.dart';
import 'package:diarys/state/hive/types/task.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";

final addTaskController = ChangeNotifierProvider<AddTaskController>((ref) {
  return AddTaskController(ref);
});

class AddTaskController with ChangeNotifier {
  final Ref _ref;

  String _subject = "";
  String get subject => _subject;

  set subject(String name) {
    _subject = name;

    if (_ref.read(subjectsController).exists(subject)) {
      setNextLessonDate(); // Will also notify listeners
    } else {
      _untilDate = AppUtils.getTomorrowDate();
      notifyListeners();
    }
  }

  String _content = "";
  String get content => _content;
  set content(String t) {
    _content = t;
    notifyListeners();
  }

  DateTime _untilDate = AppUtils.getTomorrowDate();
  DateTime get untilDate => _untilDate;
  set untilDate(DateTime date) {
    _untilDate = date;
    notifyListeners();
  }

  int _difficulty = 2;
  int get difficulty => _difficulty;
  set difficulty(int dif) {
    _difficulty = dif;
    notifyListeners();
  }

  bool _saveToSchedule = true;

  AddTaskController(this._ref);

  bool get saveToSchedule => _saveToSchedule;

  set saveToSchedule(v) {
    _saveToSchedule = v;
    notifyListeners();
  }

  bool get readyToCommit {
    return _content.isNotEmpty && _subject.isNotEmpty;
  }

  bool get subjectInSchedule =>
      _ref.read(scheduleController).dayContains(_untilDate.weekday - 1, _subject);

  Future<void> commit() async {
    if (_saveToSchedule && !subjectInSchedule) {
      final schedule = _ref.read(scheduleController);
      // Add subject to day the task is assigned to:
      // If user wants to add to some day, it probably means there's a lesson for a gived subject
      // On that day
      final until = _untilDate;
      await schedule.addLessonsToDay(until.weekday - 1, [_subject], allowDuplicate: false);
      // TODO: Run if setting to "add to current day too" is enabled
      // final today = DateTime.now();
      // if (!isSameDay(today, until)) {
      //   await schedule.addLessonsToDay(today.weekday - 1, [_data.subject], allowDuplicate: false);
      // }
    }
    _ref.read(tasksController).add(
          Task(
            subject: _subject,
            difficulty: _difficulty,
            content: _content,
            untilDate: _untilDate,
          ),
        );

    reset();
  }

  void reset() {
    _subject = "";
    _content = "";
    _difficulty = 2;
    _untilDate = AppUtils.getTomorrowDate();
    _saveToSchedule = true;
  }

  // Listeners for this one are not notified because the only place where untilDate is used
  // will be aware of change when date is changed

  void setNextLessonDate() async {
    final today = DateTime.now().weekday - 1;
    await _ref.read(scheduleController).initBox();
    var days = _ref.read(scheduleController).getDaysContainingLesson(subject);

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

    untilDate = nextLesson;
  }
}
