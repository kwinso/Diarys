import 'dart:async';

import 'package:diarys/components/date_select.dart';
import 'package:diarys/components/controllers_init.dart';
import 'package:diarys/components/elevated_button.dart';
import 'package:diarys/components/tasks/add/difficulty_select.dart';
import 'package:diarys/state/edit_task.dart';
import 'package:diarys/state/hive/controllers/schedule.dart';
import 'package:diarys/state/hive/controllers/tasks.dart';
import 'package:diarys/state/hive/types/task.dart';
import 'package:diarys/theme/colors.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: 1. Split every elemnt to own widget
// TODO: 2. Add suggestions when typing subject
// TODO: 3. Detatch DifficultySelect from addTaskController
// TODO: 4. Update button at the button from "done" to "save" and backwards when data is updated
class TaskInfo extends ConsumerWidget {
  final VoidCallback onSetDone;
  final UniqueKey id;
  TaskInfo(
    this.id, {
    Key? key,
    required this.onSetDone,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HiveControllersInit(
      controllers: [scheduleController],
      build: () => Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: TaskInfoHeader()),
            Divider(
              thickness: 2,
              color: AppUtils.getDifficultyColor(
                  ref.watch(taskEditController.select((value) => value.difficulty))),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              constraints: const BoxConstraints(minHeight: 50, maxHeight: 100),
              child: TextFormField(
                initialValue: ref.read(taskEditController).content,
                validator: (v) => v!.isEmpty ? "Домашнее задание обязательно" : null,
                onChanged: (t) => ref.read(taskEditController).content = t.trim(),
                textCapitalization: TextCapitalization.sentences,
                // maxLines: 4,
                // minLines: 1,
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: DifficultySelect(
                  selected: ref.watch(taskEditController.select((v) => v.difficulty)),
                  onSelect: (d) => ref.read(taskEditController).difficulty = d,
                  // onSelect: (d) => setState(() => info.difficulty = d),
                )),
            // TODO: Mark as done
            EditButton(
              onDone: () {
                if (_formKey.currentState!.validate()) {
                  onSetDone();
                  Navigator.pop(context);
                  Timer(Duration(milliseconds: 400), () {
                    ref.read(tasksController).remove(id);
                  });
                }
              },
              onSave: () {
                // TODO: update
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TaskInfoHeader extends ConsumerWidget {
  const TaskInfoHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: TextFormField(
          initialValue: ref.read(taskEditController).subject,
          onChanged: (s) => ref.read(taskEditController).subject,
          // maxLines: 1,
          decoration: const InputDecoration(border: InputBorder.none),
          style: const TextStyle(fontSize: 20),
        ),
      ),
      AppElevatedButton(
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
                  }));
          // showPop
        },
      ),
    ]);
  }
}

class EditButton extends ConsumerWidget {
  final VoidCallback onDone;
  final VoidCallback onSave;
  const EditButton({
    Key? key,
    required this.onDone,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEdited = ref.watch(taskEditController.select((value) => value.isEdited));
    return AppElevatedButton(
      foregroundColor: Colors.white,
      text: isEdited ? "Сохранить" : "Сделано",
      onPressed: isEdited ? onSave : onDone,
      color: isEdited ? AppColors.green : Theme.of(context).colorScheme.secondary,
    );
  }
}
