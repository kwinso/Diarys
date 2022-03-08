import 'package:diarys/components/tasks/controls.dart';
import 'package:diarys/components/tasks_list.dart';
import 'package:diarys/state/db_service.dart';
import 'package:diarys/state/tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  Widget _buildContent(BuildContext context) {
    final tasks = ref.watch(tasksController);
    final today = DateTime.now();
    // Get days that are 1 day ahead of today (basically tomorrow)
    final forTomorrow = tasks.list.all.where((e) => e.untilDate.day - today.day == 1).toList();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const TasksControls(),
            TasksList(
              header: "На завтра",
              tasks: forTomorrow,
            ),
            TasksList(
              header: "Рекомендации",
              tasks: tasks.list.recomendations,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ref.read(databaseService).openTasksBox(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildContent(context);
        }
        return Container();
      },
    );
  }

  @override
  void deactivate() {
    ref.read(databaseService).closeTasksBox();
    super.deactivate();
  }
}
