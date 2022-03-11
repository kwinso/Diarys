import 'package:diarys/state/db_service.dart';
import 'package:diarys/state/hive_types/tasks_list.dart';
import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";

final tasksController = ChangeNotifierProvider<TasksController>((ref) {
  return TasksController(ref.read(databaseService));
});

class TasksController with ChangeNotifier {
  final DatabaseService _db;
  TasksController(this._db);

  TasksList get list => _db.tasksBox.value;
}
