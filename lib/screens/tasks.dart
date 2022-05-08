import 'package:diarys/components/app_bar.dart';
import 'package:diarys/components/screen_header.dart';
import 'package:diarys/components/controllers_init.dart';
import 'package:diarys/components/sliver.dart';
import 'package:diarys/components/tasks/list.dart';
import 'package:diarys/routing.dart';
import 'package:diarys/screens/add_task.dart';
import 'package:diarys/screens/all_tasks.dart';
import 'package:diarys/state/hive/controllers/tasks.dart';
import 'package:diarys/theme/themes.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HiveControllersInit(
      controllers: [tasksController],
      build: () => const Scaffold(
        body: TasksScrollView(),
      ),
    );
  }
}

class TasksScrollView extends ConsumerWidget {
  const TasksScrollView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksController).list;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).primaryColor,
      ),
    );
    return CustomScrollView(
      slivers: [
        const CustomSliverAppBar(
          MainAppBar(),
        ),
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
                      Routing.push(
                          context, MaterialPageRoute(builder: (ctx) => const AllTasksScreen()));
                    },
                  ),
                  ScreenHeaderButton(
                    label: "Добавить",
                    icon: Icons.add_rounded,
                    onPressed: () {
                      Routing.push(context, MaterialPageRoute(builder: (ctx) => const AddTask()),
                          overlayColor: Theme.of(context).backgroundColor,
                          popOverlayColor: Theme.of(context).primaryColor);
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
