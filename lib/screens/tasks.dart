import 'package:diarys/components/tasks_list_controls.dart';
import 'package:diarys/components/controllers_init.dart';
import 'package:diarys/components/tasks/list.dart';
import 'package:diarys/state/hive/controllers/tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HiveControllersInit(
      controllers: [tasksController],
      build: () => const Scaffold(
        // resizeToAvoidBottomInset: true,
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

    return CustomScrollView(
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
              AnimatedCrossFade(
                firstChild: const Center(child: NoTasksMessage()),
                secondChild: Container(),
                crossFadeState:
                    tasks.all.isEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 200),
              ),
              TasksList(
                header: "На завтра",
                tasks: tasks.tomorrow,
              ),
              TasksList(
                header: "Рекомендации",
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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: const Text(
              "Заданий нет",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
          ),
          Text(
            "Добавьте их с помощью кнопки выше",
            style: TextStyle(color: Theme.of(context).colorScheme.tertiaryContainer),
          )
        ],
      ),
    );
  }
}
