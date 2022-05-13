import 'package:diarys/components/tasks/add_form.dart';
import 'package:diarys/components/controllers_init.dart';
import 'package:diarys/components/route_bar.dart';
import 'package:diarys/state/hive/controllers/schedule.dart';
import 'package:diarys/state/hive/controllers/tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:diarys/theme/colors.dart';
import 'package:diarys/components/elevated_button.dart';
import 'package:diarys/state/add_task.dart';

class AddTask extends ConsumerWidget {
  AddTask({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HiveControllersInit(
      controllers: [scheduleController, tasksController],
      build: () => ScaffoldMessenger(
        child: Scaffold(
          appBar: const RouteBar(
            name: "Новое задание",
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormHeader(),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: OptionalFormFields(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Visibility(
            visible: MediaQuery.of(context).viewInsets.bottom == 0,
            child: AppElevatedButton(
              foregroundColor: Theme.of(context).colorScheme.tertiary,
              text: "Добавить",
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await ref.read(addTaskController).commit();
                  Navigator.pop(context);
                }
              },
              color: AppColors.green,
            ),
          ),
        ),
      ),
    );
  }
}
