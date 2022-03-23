import 'package:diarys/components/add_task/form.dart';
import 'package:diarys/components/controllers_init.dart';
import 'package:diarys/components/route_bar.dart';
import 'package:diarys/state/add_task.dart';
import 'package:diarys/state/hive/controllers/schedule.dart';
import 'package:diarys/state/hive/controllers/tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTask extends ConsumerWidget {
  AddTask({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HiveControllersInit(
      controllers: [scheduleController, tasksController],
      build: () => ScaffoldMessenger(
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: const RouteBar(
            name: "Новое задание",
          ),
          body: SingleChildScrollView(
            child: AddTaskForm(formKey: _formKey),
          ),
          // floatingActionButton: FloatingActionButton(
          //   backgroundColor: Theme.of(context).colorScheme.secondary,
          //   onPressed: () async {
          //     if (_formKey.currentState!.validate()) {
          //       await ref.read(addTaskController).commit();
          //       Navigator.pop(context);
          //     }
          //   },
          //   child: const Icon(Icons.done),
          // ),
        ),
      ),
    );
  }
}
