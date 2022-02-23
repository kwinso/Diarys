import 'package:diarys/state/subjects.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";

final scheduleState = StateNotifierProvider<ScheduleNotifier, Schedule>((ref) {
  var schedule = List.generate(7, (int idx) => DaySchedule([]));
  return ScheduleNotifier(Schedule(schedule), ref);
});

class ScheduleNotifier extends StateNotifier<Schedule> {
  final Ref ref;

  ScheduleNotifier(Schedule s, this.ref) : super(s);

  void updateLessosNameInDay(int day, int index, String newName) {
    final newState = state.copy();
    newState.days[day].lessons[index] = newName;
    state = newState;
  }

  void removeLessonsInDay(int day, List<int> indexes) {
    final newState = state.copy();
    indexes.sort();
    for (var i in indexes.reversed) {
      newState.days[day].lessons.removeAt(i);
    }

    state = newState;
  }

  void moveLessonInDay(int day, int oldIdx, int newIdx) {
    final lessons = state.days[day].lessons;
    // Since old position is popped, we need to insert 1 pos lower
    final swap = lessons.removeAt(oldIdx);
    lessons.insert(newIdx, swap);

    // Reassign the state
    final newState = state.copy();
    state.days[day].lessons = lessons;

    state = newState;
  }

  void addLessonsToDay(int day, List<String> lessons) {
    final newState = state.copy();
    for (var l in lessons) {
      if (l.isNotEmpty) newState.days[day].lessons.add(l);
    }

    ref.watch(subjectsState.notifier).addUniqueSubjects(lessons);
    state = newState;
  }
}

class DaySchedule {
  List<String> lessons;

  DaySchedule(this.lessons);
}

class Schedule {
  List<DaySchedule> days;

  Schedule(this.days);

  Schedule copy() {
    return Schedule(this.days);
  }
}
