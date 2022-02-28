import 'package:diarys/state/db_service.dart';
import 'package:diarys/state/types/schedule.dart';
import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";

import 'subjects.dart';

final scheduleController = ChangeNotifierProvider<ScheduleController>((ref) {
  final _db = ref.watch(databaseService);

  return ScheduleController(_db, ref);
});

class ScheduleController with ChangeNotifier {
  late final DatabaseService _db;
  final Ref _ref;

  ScheduleController(this._db, this._ref);

  Schedule get state => _db.daysSchedule;

  void _updateState(Schedule updated) {
    _db.updateSchedule(updated);
    notifyListeners();
  }

  void updateLessosNameInDay(int day, int index, String newName) {
    final updated = state;
    updated.days[day].lessons[index] = newName;

    _ref.read(subjectsController).addSubjects([newName]);
    _updateState(updated);
  }

  void removeLessonsInDay(int day, List<int> indexes) {
    final updated = state;
    List<String> removed = [];
    indexes.sort();
    for (var i in indexes.reversed) {
      final l = updated.days[day].lessons.removeAt(i);
      removed.add(l);
    }
    _ref.read(subjectsController).removeSubjectRefs(removed);
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

    _ref.read(subjectsController).addSubjects(lessons);
    _updateState(updated);
  }
}
