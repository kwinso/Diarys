import 'package:diarys/components/add_task/form.dart';
import 'package:diarys/components/controllers_init.dart';
import 'package:diarys/components/elevated_button.dart';
import 'package:diarys/components/route_bar.dart';
import 'package:diarys/state/add_task.dart';
import 'package:diarys/state/hive/controllers/schedule.dart';
import 'package:diarys/state/hive/controllers/tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTask extends ConsumerWidget {
  AddTask({Key? key}) : super(key: key);

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
            child: AddTaskForm(),
          ),
          // bottomNavigationBar: SafeArea(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Padding(
          //         padding: EdgeInsets.only(bottom: 10),
          //         child:                 ),
          //     ],
          //   ),
          // ),
        ),

        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Theme.of(context).colorScheme.secondary,
        //   onPressed: () async {
        //   child: const Icon(Icons.done),
        // ),
      ),
    );
  }
}
