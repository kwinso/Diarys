import 'package:diarys/components/route_bar.dart';
import 'package:diarys/components/tasks/list.dart';
import 'package:diarys/state/hive/controllers/tasks.dart';
import 'package:diarys/state/hive/types/task.dart';
import 'package:diarys/texts.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class AllTasksScreen extends ConsumerWidget {
  const AllTasksScreen({Key? key}) : super(key: key);

  List<TasksList> _getList(WidgetRef ref) {
    final tasks = ref.watch(tasksController).list.all;

    if (tasks.isEmpty) return [];

    tasks.sort(((a, b) => a.untilDate.compareTo(b.untilDate)));
    var tasksForDays = <TasksList>[];
    var currentList = <Task>[];

    for (var i = 0; i < tasks.length; i++) {
      final date = tasks[i].untilDate;
      var title = AppTexts.week.days[date.weekday - 1];
      // TODO: Make for exceptions for whole week and only then start counting as dates
      if (isSameDay(AppUtils.getTomorrowDate(), date)) title = "На завтра";

      currentList.add(tasks[i]);

      if (i + 1 == tasks.length || !isSameDay(date, tasks[i + 1].untilDate)) {
        // TODO: Make some sign for missed day instead of this
        if (date.isBefore(DateTime.now())) title += " (П)";

        tasksForDays.add(TasksList(
          title: title,
          dateLabel: AppUtils.formatDate(date),
          tasks: List.from(currentList),
        ));
        currentList.clear();
      }
    }

    return tasksForDays;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = _getList(ref);
    final appBar = RouteBar(
      name: "Задания",
      sliver: list.isNotEmpty,
    );

    if (list.isEmpty) {
      return Scaffold(
        appBar: appBar,
        backgroundColor: Theme.of(context).backgroundColor,
        body: Center(
          child: Text(
            "Заданий еще нет",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              color: Theme.of(context).colorScheme.tertiaryContainer,
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            const RouteBar(
              name: "Задания",
              sliver: true,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: list
                        .map((e) => SizedBox(
                              key: e.tasks.first.id,
                              width: double.infinity,
                              child: e,
                            ))
                        .toList(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
