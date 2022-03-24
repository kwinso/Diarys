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

@HiveType(typeId: 5)
class TasksList {
  @HiveField(0)
  List<Task> all;

  @HiveField(1)
  List<Task> tomorrow = [];

  @HiveField(2)
  List<Task> recomendations = [];

  void _updateLists() {
    _udpdateTomorrow(null);
    _updateRecomendations(null);
  }

  void add(Task task) {
    all.add(task);
    _updateLists();
  }

  void remove(UniqueKey id) {
    all.removeWhere((e) => e.id == id);
    _updateLists();
  }

  void _udpdateTomorrow(List<Task>? l) {
    if (l != null) {
      tomorrow = l;
      return;
    }

    var tomorrowDate = AppUtils.getTomorrowDate();
    tomorrow = all.where((e) => isSameDay(e.untilDate, tomorrowDate)).toList();
  }

  void _updateRecomendations(List<Task>? l) {
    if (l != null) {
      recomendations = l;
      return;
    }
    recomendations.clear();

    var tasks = List<Task>.from(all);
    var tomorrowDate = AppUtils.getTomorrowDate();
    tasks.removeWhere((e) => isSameDay(e.untilDate, tomorrowDate));

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
    _udpdateTomorrow(tomorrow);
    _updateRecomendations(recomendations);
  }
}
