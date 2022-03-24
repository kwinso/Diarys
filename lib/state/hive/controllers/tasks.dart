import 'dart:math';

import 'package:diarys/state/hive/controllers/hive_notifier.dart';
import 'package:diarys/state/hive/types/task.dart';
import 'package:diarys/state/hive/types/tasks_list.dart';
import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:hive/hive.dart';

final tasksController = ChangeNotifierProvider<TasksController>((ref) {
  return TasksController();
});

class TasksController extends HiveChangeNotifier<TasksList> {
  TasksController() : super('tasks');

  @override
  Future<dynamic> emptyBoxFill(Box<TasksList> box) async {
    // final startDay = DateTime.now();
    // final days = [
    //   DateTime(startDay.year, startDay.month, startDay.day + 0),
    //   DateTime(startDay.year, startDay.month, startDay.day + 1),
    //   DateTime(startDay.year, startDay.month, startDay.day + 1),
    //   DateTime(startDay.year, startDay.month, startDay.day + 1),
    //   DateTime(startDay.year, startDay.month, startDay.day + 2),
    //   DateTime(startDay.year, startDay.month, startDay.day + 2),
    //   DateTime(startDay.year, startDay.month, startDay.day + 5),
    //   DateTime(startDay.year, startDay.month, startDay.day + 6),
    //   DateTime(startDay.year, startDay.month, startDay.day + 3),
    // ];

    // final tasks = List.generate(days.length, (index) {
    //   final rnd = Random().nextInt(4);
    //   return Task(
    //       subject: "Алгебра",
    //       difficulty: rnd == 0 ? 1 : rnd,
    //       content: "Какое-то дз.",
    //       untilDate: days[index]);
    // });

    await box.add(TasksList([]));
  }

  TasksList get list {
    final l = box.values.first;
    return TasksList(l.all, recomendations: l.recomendations, tomorrow: l.tomorrow);
  }

  void add(Task t) {
    final updated = list;
    updated.add(t);
    updateBox(updated);
  }

  // TODO: Archive deleted
  void remove(UniqueKey id) {
    final updated = list;
    updated.remove(id);
    updateBox(updated);
  }
}
