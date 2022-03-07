import 'package:hive/hive.dart';

part 'day_schedule.g.dart';

@HiveType(typeId: 2)
class DaySchedule {
  @HiveField(0, defaultValue: [])
  List<String> lessons;

  DaySchedule(this.lessons);
}
