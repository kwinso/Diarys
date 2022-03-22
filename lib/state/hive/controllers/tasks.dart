import 'package:diarys/state/hive/controllers/hive_notifier.dart';
import 'package:diarys/state/hive/types/task.dart';
import 'package:diarys/state/hive/types/tasks_list.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:hive/hive.dart';

final tasksController = ChangeNotifierProvider<TasksController>((ref) {
  return TasksController();
});

class TasksController extends HiveChangeNotifier<TasksList> {
  TasksController() : super('tasks');

  @override
  Future<dynamic> emptyBoxFill(Box<TasksList> box) async {
    final startDay = DateTime.now();
    final days =
        List.generate(4, (index) => DateTime(startDay.year, startDay.month, startDay.day + index));
    final tasks = List.generate(
        4,
        (index) => Task(
            subject: "Алгебра",
            difficulty: index,
            content: "Какое-то дз.",
            untilDate: days[index]));

    await box.add(TasksList(
      all: tasks,
      recomendations: [],
    ));
  }

  TasksList get list {
    final l = box.values.first;
    return TasksList(all: l.all, recomendations: l.recomendations);
  }

  void add(Task t) {
    final newList = list;
    newList.all.add(t);
    updateBox(newList);
  }
}
