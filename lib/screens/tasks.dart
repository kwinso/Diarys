import 'package:diarys/components/main_app_bar.dart';
import 'package:diarys/components/route_bar.dart';
import 'package:diarys/components/screen_header.dart';
import 'package:diarys/components/controllers_init.dart';
import 'package:diarys/components/tasks/list.dart';
import 'package:diarys/screens/add_task.dart';
import 'package:diarys/screens/all_tasks.dart';
import 'package:diarys/state/hive/controllers/tasks.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HiveControllersInit(
      controllers: [tasksController],
      build: () => TasksScrollView(),
    );
  }
}

// TODO: Task does not delete on the first try after navigating to schedule and back
class TasksScrollView extends ConsumerWidget {
  const TasksScrollView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksController).list;

    return CustomScrollView(
      slivers: [
        const MainAppBar(),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              ScreenHeader(
                title: "Задания",
                buttons: [
                  ScreenHeaderButton(
                    label: "Все задания",
                    icon: Icons.subject_rounded,
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (ctx) => const AllTasksScreen()));
                    },
                  ),
                  ScreenHeaderButton(
                    label: "Добавить",
                    icon: Icons.add_rounded,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => AddTask()));
                    },
                  ),
                ],
              ),
              AnimatedCrossFade(
                firstChild: const Center(child: NoTasksMessage()),
                secondChild: Container(),
                crossFadeState:
                    tasks.all.isEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 200),
              ),
              TasksList(
                title: "На завтра",
                dateLabel: AppUtils.formatDate(AppUtils.getTomorrowDate()),
                tasks: tasks.tomorrow,
              ),
              TasksList(
                title: "Рекомендации",
                tasks: tasks.recomendations,
              )
            ],
          ),
        ),
      ],
    );
  }
}

class NoTasksMessage extends StatelessWidget {
  const NoTasksMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        "Заданий нет",
        style: TextStyle(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          fontSize: 25,
        ),
      ),
    );
  }
}
