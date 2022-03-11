import 'package:diarys/state/db_service.dart';
import 'package:diarys/state/hive_types/schedule.dart';
import 'package:diarys/state/subjects.dart';
import 'package:diarys/state/types/delete_entry.dart';
import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";

final scheduleController = ChangeNotifierProvider<ScheduleController>((ref) {
  final _db = ref.watch(databaseService);

  return ScheduleController(_db, ref);
});

class ScheduleController with ChangeNotifier {
  late final DatabaseService _db;
  final Ref _ref;

  ScheduleController(this._db, this._ref);

  Schedule get state => _db.scheduleBox.value;

  void _updateState(Schedule update) {
    _db.scheduleBox.updateValue(update);
    notifyListeners();
  }

  void updateLessosNameInDay(int day, int index, String newName) {
    final updated = state;
    final oldName = updated.days[day].lessons[index];
    updated.days[day].lessons[index] = newName;

    final subjects = _ref.read(subjectsController);
    subjects.removeSubjectRefs([oldName]);
    subjects.addSubjectsOrRefs([newName]);
    _updateState(updated);
  }

  void removeLessons(List<DeleteEntry> removed) {
    final updated = state;
    List<String> removedNames = [];

    // This impls logic of reverse sotring for DeleteEntry
    removed.sort(((a, b) {
      return a.index.compareTo(b.index);
    }));

    for (var i in removed.reversed) {
      final l = updated.days[i.day].lessons.removeAt(i.index);
      removedNames.add(l);
    }
    _ref.read(subjectsController).removeSubjectRefs(removedNames);
    _updateState(updated);
  }

  void moveLessonInDay(int day, int oldIdx, int newIdx) {
    final lessons = state.days[day].lessons;
    // Since old position is popped, we need to insert 1 pos lower
    final swap = lessons.removeAt(oldIdx);
    lessons.insert(newIdx, swap);
    final updated = state;
    updated.days[day].lessons = lessons;

    _updateState(updated);
  }

  void addLessonsToDay(int day, List<String> lessons) {
    final updated = state;
    for (var l in lessons) {
      if (l.isNotEmpty) updated.days[day].lessons.add(l);
    }

    _ref.read(subjectsController).addSubjectsOrRefs(lessons);
    _updateState(updated);
  }

  List<int> getDaysContainingLesson(String lesson) {
    var days = <int>[];
    state.days.asMap().forEach((key, value) {
      if (value.lessons.contains(lesson)) days.add(key);
    });

    return days;
  }
}
