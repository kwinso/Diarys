import 'package:diarys/components/tasks/add/form.dart';
import 'package:diarys/components/controllers_init.dart';
import 'package:diarys/components/route_bar.dart';
import 'package:diarys/state/hive/controllers/schedule.dart';
import 'package:diarys/state/hive/controllers/tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTask extends ConsumerWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HiveControllersInit(
      controllers: [scheduleController, tasksController],
      build: () => ScaffoldMessenger(
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: RouteBar(
              name: "Новое задание",
              backgroundColor: Theme.of(context).backgroundColor,
            ),
            body: SingleChildScrollView(
              child: AddTaskForm(),
            ),
          ),
        ),
      ),
    );
  }
}
