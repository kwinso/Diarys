import 'package:diarys/state/hive/controllers/hive_notifier.dart';
import 'package:diarys/state/hive/types/day_schedule.dart';
import 'package:diarys/state/hive/types/schedule.dart';
import 'package:diarys/state/hive/controllers/subjects.dart';
import 'package:diarys/state/types/delete_entry.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:hive/hive.dart';

final scheduleController = ChangeNotifierProvider<ScheduleController>((ref) {
  // final _db = ref.watch(databaseService);

  return ScheduleController(ref);
});

class ScheduleController extends HiveChangeNotifier<Schedule> {
  final Ref _ref;

  ScheduleController(this._ref) : super('schedule');

  Schedule get state => Schedule(box.values.first.days);

  @override
  Future<dynamic> emptyBoxFill(Box<Schedule> box) async {
    final days = List<DaySchedule>.generate(7, (int idx) => DaySchedule([]));
    await box.add(Schedule(days));
  }

  Future<void> updateLessosNameInDay(int day, int index, String newName) async {
    final updated = state;
    final oldName = updated.days[day].lessons[index];
    updated.days[day].lessons[index] = newName;

    final subjects = _ref.read(subjectsController);
    subjects.removeSubjectRefs([oldName]);
    subjects.addSubjectsOrRefs([newName]);

    await updateBox(updated);
  }

  Future<void> removeLessons(List<DeleteEntry> removed) async {
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

    await updateBox(updated);
  }

  Future<void> moveLessonInDay(int day, int oldIdx, int newIdx) async {
    final lessons = state.days[day].lessons;
    // Since old position is popped, we need to insert 1 pos lower
    final swap = lessons.removeAt(oldIdx);
    lessons.insert(newIdx, swap);
    final updated = state;
    updated.days[day].lessons = lessons;

    await updateBox(updated);
  }

  Future<void> addLessonsToDay(int day, List<String> lessons,
      {bool allowDuplicate = true}) async {
    final updated = state;
    for (var l in lessons) {
      if (l.isNotEmpty) {
        final d = updated.days[day];
        if (d.lessons.contains(l) && !allowDuplicate) continue;

        d.lessons.add(l);
      }
    }

    _ref.read(subjectsController).addSubjectsOrRefs(lessons);

    await updateBox(updated);
  }

  List<int> getDaysContainingLesson(String lesson) {
    var days = <int>[];
    state.days.asMap().forEach((key, value) {
      if (value.lessons.contains(lesson)) days.add(key);
    });

    return days;
  }

  bool dayContains(int day, String subject) =>
      state.days[day].lessons.contains(subject);
}
