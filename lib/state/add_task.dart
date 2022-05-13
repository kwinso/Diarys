import 'package:diarys/state/edit_task.dart';
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

class AddTaskController extends TaskEditController {
  AddTaskController(ref) : super(ref);

  bool _saveToSchedule = true;

  @override
  set subject(String name) {
    subject = name;

    if (ref.read(subjectsController).exists(subject)) {
      setNextLessonDate(); // Will also notify listeners
    } else {
      untilDate = AppUtils.getTomorrowDate();
      notifyListeners();
    }
  }

  bool get saveToSchedule => _saveToSchedule;

  set saveToSchedule(v) {
    _saveToSchedule = v;
    notifyListeners();
  }

  @override
  Future<void> commit() async {
    if (_saveToSchedule && !subjectInSchedule) {
      final schedule = ref.read(scheduleController);
      // Add subject to day the task is assigned to:
      // If user wants to add to some day, it probably means there's a lesson for a gived subject
      // On that day
      final until = untilDate;
      await schedule.addLessonsToDay(until.weekday - 1, [subject], allowDuplicate: false);
      // TODO: Run if setting to "add to current day too" is enabled
      // final today = DateTime.now();
      // if (!isSameDay(today, until)) {
      //   await schedule.addLessonsToDay(today.weekday - 1, [_data.subject], allowDuplicate: false);
      // }
    }
    ref.read(tasksController).add(
          Task(
            subject: subject,
            difficulty: difficulty,
            content: content,
            untilDate: untilDate,
          ),
        );

    reset();
  }

  void reset() {
    _saveToSchedule = true;
    subject = "";
    content = "";
    difficulty = 2;
    untilDate = AppUtils.getTomorrowDate();

    notifyListeners();
  }

  // Listeners for this one are not notified because the only place where untilDate is used
  // will be aware of change when date is changed
  void setNextLessonDate() async {
    final today = DateTime.now().weekday - 1;
    await ref.read(scheduleController).initBox();
    var days = ref.read(scheduleController).getDaysContainingLesson(subject);

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
