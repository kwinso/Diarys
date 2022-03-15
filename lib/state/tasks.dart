import 'package:diarys/state/hive_notifier.dart';
import 'package:diarys/state/hive_types/task.dart';
import 'package:diarys/state/hive_types/tasks_list.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:hive/hive.dart';

final tasksController = ChangeNotifierProvider<TasksController>((ref) {
  return TasksController();
});

class TasksController extends HiveChangeNotifier<TasksList> {
  TasksController() : super('tasks');

  @override
  dynamic emptyBoxFill(Box<TasksList> box) {
    // TODO: remove
    final now = DateTime.now();
    final dummy = List.generate(
      3,
      (index) => Task(
        subject: "Алгебра",
        difficulty: index + 1,
        textContent: "Какая-то длинная домашка глупая математичка блин",
        untilDate: DateTime(now.year, now.month, now.day + 1),
      ),
    );
    box.add(TasksList(
      all: dummy,
      recomendations: dummy,
    ));
  }

  TasksList get list {
    final l = box.values.first;
    return TasksList(all: l.all, recomendations: l.recomendations);
  }
}
