import 'package:diarys/components/controllers_init.dart';
import 'package:diarys/components/route_bar.dart';
import 'package:diarys/components/tasks_list.dart';
import 'package:diarys/state/hive/controllers/tasks.dart';
import 'package:diarys/state/hive/types/task.dart';
import 'package:diarys/theme/colors.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class AllTasksScreen extends ConsumerWidget {
  const AllTasksScreen({Key? key}) : super(key: key);

  List<TasksList> _getList(WidgetRef ref) {
    final tasks = ref.read(tasksController).list.all;

    if (tasks.isEmpty) return [];

    tasks.sort(((a, b) => a.untilDate.compareTo(b.untilDate)));
    var tasksForDays = <TasksList>[];
    var currentDay = tasks.first.untilDate;
    var currentList = <Task>[];

    for (var i = 0; i < tasks.length; i++) {
      final date = tasks[i].untilDate;
      var title = AppUtils.formatDate(date);
      // TODO: Make for exceptions for whole week and only then start counting as dates
      if (isSameDay(AppUtils.addOneDayToDate(DateTime.now()), date)) title = "На завтра";

      // final title =
      currentList.add(tasks[i]);

      if (i + 1 == tasks.length || !isSameDay(date, tasks[i + 1].untilDate)) {
        if (date.isBefore(DateTime.now())) title += " (Просрочено)";

        currentDay = date;
        tasksForDays.add(TasksList(header: title, tasks: List.from(currentList)));
        currentList.clear();
      }
    }

    return tasksForDays;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HiveControllersInit(
      controllers: [tasksController],
      build: () {
        final list = _getList(ref);
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: const RouteBar(name: "Все задания"),
          body: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: list.isNotEmpty
                  ? list
                      .map((e) => SizedBox(
                            width: double.infinity,
                            child: e,
                          ))
                      .toList()
                  : [
                      // TODO: Fix
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Заданий еще нет",
                          style: TextStyle(
                            fontSize: 25,
                            color: Theme.of(context).colorScheme.tertiaryContainer,
                          ),
                        ),
                      )
                    ],
            ),
          ),
        );
      },
    );
  }
}
