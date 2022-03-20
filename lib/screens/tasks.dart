import 'package:diarys/components/tasks_list_controls.dart';
import 'package:diarys/components/controllers_init.dart';
import 'package:diarys/components/tasks_list.dart';
import 'package:diarys/state/hive/controllers/tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HiveControllersInit(
        controllers: [tasksController],
        build: () {
          final tasks = ref.watch(tasksController);
          final today = DateTime.now();
          // Get days that are 1 day ahead of today (basically tomorrow)
          final forTomorrow =
              tasks.list.all.where((e) => e.untilDate.day - today.day == 1).toList();
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  // pinned: true,
                  expandedHeight: 70,
                  collapsedHeight: 70,
                  flexibleSpace: Container(
                    decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
                    child: const TasksControls(),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      TasksList(
                        header: "На завтра",
                        tasks: forTomorrow,
                      ),
                      TasksList(
                        header: "Рекомендации",
                        // TODO: Change with recomendations later
                        tasks: tasks.list.all,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
