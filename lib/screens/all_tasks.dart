import 'package:diarys/components/route_bar.dart';
import 'package:diarys/components/tasks/list.dart';
import 'package:diarys/state/hive/controllers/tasks.dart';
import 'package:diarys/state/hive/types/task.dart';
import 'package:diarys/texts.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class AllTasksScreen extends ConsumerStatefulWidget {
  const AllTasksScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AllTasksScreen> createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends ConsumerState<AllTasksScreen> {
  @override
  void deactivate() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ref.read(tasksController).clearQueue();
    super.deactivate();
  }

  List<TasksList> _getList(WidgetRef ref) {
    final tasks = ref.watch(tasksController).list.all;

    if (tasks.isEmpty) return [];

    tasks.sort(((a, b) => a.untilDate.compareTo(b.untilDate)));
    var tasksForDays = <TasksList>[];
    var currentList = <Task>[];

    for (var i = 0; i < tasks.length; i++) {
      final date = tasks[i].untilDate;
      var title = AppTexts.week.days[date.weekday - 1];
      var missed = false;
      if (isSameDay(AppUtils.getTomorrowDate(), date)) title = "На завтра";

      currentList.add(tasks[i]);

      if (i + 1 == tasks.length || !isSameDay(date, tasks[i + 1].untilDate)) {
        missed = date.isBefore(DateTime.now());

        tasksForDays.add(TasksList(
          title: title,
          missied: missed,
          dateLabel: AppUtils.formatDate(date),
          tasks: List.from(currentList),
        ));
        currentList.clear();
      }
    }

    return tasksForDays;
  }

  @override
  Widget build(BuildContext context) {
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
                        .map((e) => Container(
                              key: Key(e.dateLabel!),
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
