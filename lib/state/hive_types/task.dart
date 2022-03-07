import 'package:hive/hive.dart';

part "task.g.dart";

@HiveType(typeId: 6)
class Task {
  @HiveField(0)
  String subject;

  @HiveField(1)
  DateTime untilDate;

  @HiveField(2)
  int difficulty;

  @HiveField(3)
  String textContent;

  Task(
      {required this.subject,
      required this.difficulty,
      required this.textContent,
      required this.untilDate});
}
