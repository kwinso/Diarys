import 'package:hive/hive.dart';

import 'day_schedule.dart';

part 'schedule.g.dart';

@HiveType(typeId: 1)
class Schedule {
  @HiveField(0, defaultValue: [])
  List<DaySchedule> days;

  Schedule(this.days);
}
