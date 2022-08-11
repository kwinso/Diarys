import 'package:diarys/state/hive/types/task.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:table_calendar/table_calendar.dart';

part "tasks_list.g.dart";

// 10 points is considered maximum tasks difficulties sum for 1 day
// This includes both tomorrow and recomendations
const maxDayWeight = 10;
const maxTasksPerDay = 6;

// TODO:
// - Make up list of days
// - Sort days by difficulty & date
// - Pick first lessons that make up weight of 10 with tomorrow tasks
// - Save the days list, insert new tasks into it so we can skip first step

@HiveType(typeId: 5)
class TasksList {
  @HiveField(0)
  List<Task> all;

  List<Task> tomorrow = [];

  List<Task> recomendations = [];

  void _updateLists() {
    _udpdateTomorrow();
    _updateRecomendations();
  }

  void add(Task task) {
    all.add(task);
    _updateLists();
  }

  void remove(UniqueKey id) {
    all.removeWhere((e) => e.id == id);
    _updateLists();
  }

  void _udpdateTomorrow() {
    var tomorrowDate = AppUtils.getTomorrowDate();
    tomorrow = all.where((e) => isSameDay(e.untilDate, tomorrowDate)).toList();
  }

  void _updateRecomendations() {
    recomendations.clear();

    var tasks = List<Task>.from(all);
    var tomorrowDate = AppUtils.getTomorrowDate();
    tasks.removeWhere((e) => isSameDay(e.untilDate, tomorrowDate));
    // for (var t in tasks){ }
    // AppUtils.formatDate(d)

    // tasks[0].untilDate.
    // const days =

    tasks.sort((a, b) {
      var difComp = a.difficulty.compareTo(b.difficulty);
      if (difComp == 0) return a.untilDate.compareTo(b.untilDate);

      return difComp;
    });

    var recomendationsWeight = _getTasksDifficulties(tomorrow);
    for (var t in tasks.reversed) {
      if (recomendationsWeight + t.difficulty <= maxDayWeight) {
        if (recomendations.length + tomorrow.length < maxTasksPerDay) {
          recomendationsWeight += t.difficulty;
          recomendations.add(t);
        }
      }
    }
  }

  int _getTasksDifficulties(List<Task> tasks) {
    var difficulties = 0;
    for (var t in tasks) {
      difficulties += t.difficulty;
    }

    return difficulties;
  }

  TasksList(this.all, {List<Task>? tomorrow, List<Task>? recomendations}) {
    _udpdateTomorrow();
    _updateRecomendations();
  }
}
