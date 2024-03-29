import 'dart:async';
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
    await box.add(TasksList([]));
  }

  TasksList get list {
    final l = box!.values.first;
    return TasksList(l.all);
  }

  void add(Task t) {
    final updated = list;
    updated.add(t);
    updateBox(updated);
  }

  void update(UniqueKey id, Task data) {
    final updated = list;
    final updatedIndex = updated.all.indexWhere((e) => e.id == id);
    updated.all[updatedIndex] = data;

    updateBox(updated);
  }

  UniqueKey? _queuedRemoval;
  VoidCallback? _lastCallback;
  Timer? _queueTimer;

  void undoRemoval() {
    _queuedRemoval = null;
    _lastCallback = null;
    _queueTimer?.cancel();
    _queueTimer = null;
  }

  Future<void> clearQueue() async {
    if (_queuedRemoval != null) {
      await remove(_queuedRemoval);
      _lastCallback?.call();

      _queuedRemoval = null;
      _lastCallback = null;
      _queueTimer = null;
    }
  }

  /// Returns `true` if there was an item in queue before inserting new one
  Future<bool> queueRemoval(
      UniqueKey id, Duration queueDuration, VoidCallback onRemove) async {
    var removed = _queueTimer != null;
    _queueTimer?.cancel();
    await clearQueue();

    _queuedRemoval = id;
    _lastCallback = onRemove;

    // Forbid to close the box before before deleting
    _queueTimer = Timer(queueDuration, clearQueue);

    return removed;
  }

  Future<void> remove(UniqueKey? id) async {
    if (id != null) {
      final updated = list;
      updated.remove(id);
      await updateBox(updated);
    }
  }

  @override
  void unsubscribe() async {
    await clearQueue();
    super.unsubscribe();
  }
}
