import "package:flutter_riverpod/flutter_riverpod.dart";

final scheduleController = StateNotifierProvider<ScheduleNotifier, Schedule>((ref) {
  var schedule = List.generate(7, (int idx) => DaySchedule([]));
  return ScheduleNotifier(Schedule(schedule));
});

class ScheduleNotifier extends StateNotifier<Schedule> {
  ScheduleNotifier(Schedule s) : super(s);

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
