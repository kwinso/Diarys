import 'package:diarys/state/hive/controllers/schedule.dart';
import 'package:diarys/state/hive/controllers/tasks.dart';
import 'package:diarys/state/hive/types/task.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";

final taskEditController = ChangeNotifierProvider<TaskEditController>((ref) {
  return TaskEditController(ref);
});

class TaskEditController with ChangeNotifier {
  final Ref ref;
  late UniqueKey _taskId;

  TaskEditController(this.ref);

  void commitAndNotifyListeners() {
    _edited = false;
    super.notifyListeners();
  }

  @override
  void notifyListeners() {
    _edited = true;
    super.notifyListeners();
  }

  UniqueKey get taskId => _taskId;

  bool _edited = false;
  bool get isEdited => _edited;

  String _subject = "";
  String get subject => _subject;
  set subject(String s) {
    _subject = s;
    notifyListeners();
  }

  String _content = "";
  String get content => _content;
  set content(String t) {
    _content = t;
    notifyListeners();
  }

  DateTime _untilDate = AppUtils.getTomorrowDate();
  DateTime get untilDate => _untilDate;
  set untilDate(DateTime date) {
    _untilDate = date;
    notifyListeners();
  }

  int _difficulty = 1;
  int get difficulty => _difficulty;
  set difficulty(int dif) {
    _difficulty = dif;
    notifyListeners();
  }

  bool get readyToCommit {
    return _content.isNotEmpty && _subject.isNotEmpty;
  }

  Future<void> commit() async {
    ref.read(tasksController).update(
          _taskId,
          Task(
            subject: _subject,
            difficulty: _difficulty,
            content: _content,
            untilDate: _untilDate,
            existingId: _taskId,
          ),
        );
    commitAndNotifyListeners();
  }

  Future<void> deleteTask() async {
    ref.read(tasksController).remove(_taskId);
  }

  void update(Task t) {
    _subject = t.subject;
    _content = t.content;
    _difficulty = t.difficulty;
    _untilDate = t.untilDate;
    _taskId = t.id;
    _edited = false;
  }
}
