import "package:flutter_riverpod/flutter_riverpod.dart";

final scheduleController = StateNotifierProvider<ScheduleNotifier, Schedule>((ref) {
  var schedule = List.generate(7, (int idx) => DaySchedule([]));
  return ScheduleNotifier(Schedule(schedule));
});

class ScheduleNotifier extends StateNotifier<Schedule> {
  ScheduleNotifier(Schedule s) : super(s);

  void removeLessonsInDay(int day, List<int> indexes) {
    final newState = Schedule(state.days);
    indexes.sort();
    for (var i in indexes.reversed) {
      newState.days[day].lessons.removeAt(i);
    }

    state = newState;
  }

  void moveLessonInDay(int day, int oldIdx, int newIdx) {
    final lessons = state.days[day].lessons;
    // Since old position is popped, we need to insert 1 pos lower
    final idx = newIdx > oldIdx ? newIdx - 1 : newIdx;
    final swap = lessons.removeAt(oldIdx);
    lessons.insert(idx, swap);

    // Reassign the state
    final newState = Schedule(state.days);
    state.days[day].lessons = lessons;

    state = newState;
  }

  void addLessonsToDay(int day, List<String> lessons) {
    final newState = Schedule(state.days);
    for (var l in lessons) {
      if (l.isNotEmpty) newState.days[day].lessons.add(l);
    }
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
}
