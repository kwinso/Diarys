import 'package:diarys/components/controllers_init.dart';
import 'package:diarys/components/date_select.dart';
import 'package:diarys/components/elevated_button.dart';
import 'package:diarys/components/route_bar.dart';
import 'package:diarys/components/tasks/difficulty_select.dart';
import 'package:diarys/components/tasks/field_label.dart';
import 'package:diarys/components/tasks/task_text_input.dart';
import 'package:diarys/state/edit_task.dart';
import 'package:diarys/state/hive/controllers/schedule.dart';
import 'package:diarys/state/hive/controllers/tasks.dart';
import 'package:diarys/state/hive/types/task.dart';
import 'package:diarys/theme/colors.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskInfoPage extends ConsumerWidget {
  final Task task;
  const TaskInfoPage(this.task, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(taskEditController).update(task);

    return Scaffold(
      appBar: const RouteBar(name: "Задание"),
      body: HiveControllersInit(
        controllers: [tasksController, scheduleController],
        build: () => SafeArea(
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                children: const [
                  _TaskInfoHeader(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: _TaskInfoOptional(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskInfoHeader extends ConsumerWidget {
  const _TaskInfoHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(15),
      color: Theme.of(context).primaryColor,
      child: Column(children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextFormField(
                style: const TextStyle(fontSize: 25),
                initialValue: ref.read(taskEditController).subject,
                onChanged: (t) {
                  ref.read(taskEditController).subject = t.trim();
                },
                maxLines: 1,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
            const _ControlButton(),
          ],
        ),
        DifficultySelect(
          selected: ref.watch(taskEditController.select((v) => v.difficulty)),
          onSelect: (i) {
            ref.read(taskEditController).difficulty = i;
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Дата",
                style: TextStyle(fontSize: 18),
              ),
              AppElevatedButton(
                color: Theme.of(context).backgroundColor,
                text: AppUtils.formatDate(ref.watch(taskEditController.select((v) => v.untilDate))),
                onPressed: () {
                  AppUtils.showBottomSheet(
                    context: context,
                    builder: (ctx) => DateSelectCalendar(
                      subject: ref.read(taskEditController).subject,
                      selected: ref.read(taskEditController).untilDate,
                      onSubmit: (d) {
                        Navigator.pop(ctx);
                        ref.read(taskEditController).untilDate = d;
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class _ControlButton extends ConsumerWidget {
  const _ControlButton({
    Key? key,
  }) : super(key: key);

  Icon getCurrentIcon(
    BuildContext context,
    bool isEdited,
  ) {
    Color c = isEdited
        ? Theme.of(context).colorScheme.secondary
        : Theme.of(context).colorScheme.tertiaryContainer;
    IconData i = isEdited ? Icons.save_as_outlined : Icons.done_rounded;

    return Icon(i, color: c, size: 30);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEdited = ref.watch(taskEditController).isEdited;
    return WillPopScope(
      onWillPop: () async {
        if (isEdited) {
          var res = showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Изменения задания не сохранены!"),
                  titleTextStyle:
                      TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.tertiary),
                  backgroundColor: Theme.of(context).backgroundColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  actions: [
                    AppElevatedButton(
                      text: "Отмена",
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    AppElevatedButton(
                      text: "Сохранить",
                      color: AppColors.green,
                      foregroundColor: Colors.white,
                      onPressed: () {
                        ref.read(taskEditController).commit();
                        Navigator.of(context).pop(true);
                      },
                    )
                  ],
                );
              });

          return (await res) ?? false;
        }

        return true;
      },
      child: IconButton(
          onPressed: () {
            if (isEdited) {
              ref.read(taskEditController).commit();
            } else {
              ref.read(taskEditController).deleteTask();
              Navigator.pop(context);
            }
          },
          icon: getCurrentIcon(context, isEdited)),
    );
  }
}

class _TaskInfoOptional extends StatelessWidget {
  const _TaskInfoOptional({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TaskFieldLabel("Задание"),
          TaskTextInput(controller: taskEditController),
        ],
      ),
    );
  }
}
