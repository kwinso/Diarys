import 'package:diarys/state/hive_types/task.dart';
import 'package:hive/hive.dart';

part "tasks_list.g.dart";

@HiveType(typeId: 5)
class TasksList {
  @HiveField(0)
  List<Task> all;

  @HiveField(1)
  List<Task> recomendations;

  TasksList({
    required this.all,
    required this.recomendations,
  });
}
