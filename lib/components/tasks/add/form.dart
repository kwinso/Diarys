import 'package:diarys/components/tasks/add/date_dropdown.dart';
import 'package:diarys/components/tasks/add/difficulty_select.dart';
import 'package:diarys/components/tasks/add/label.dart';
import 'package:diarys/components/tasks/add/save_to_schedule.dart';
import 'package:diarys/components/tasks/add/subject_input.dart';
import 'package:diarys/components/elevated_button.dart';
import 'package:diarys/state/add_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTaskForm extends ConsumerWidget {
  AddTaskForm({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      key: formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SubjectInput(),
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: DateSelectDropdown(),
            ),
            const AddTaskLabel("Укажите сложность: "),
            DifficultySelect(
              selected: ref.watch(addTaskController.select((value) => value.difficulty)),
              onSelect: (d) => ref.read(addTaskController).difficulty = d,
            ),
            const AddTaskLabel("Введите текст задания: "),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              constraints: const BoxConstraints(minHeight: 50, maxHeight: 100),
              child: TextFormField(
                initialValue: ref.read(addTaskController).content,
                validator: (v) => v!.isEmpty ? "Домашнее задание обязательно" : null,
                onChanged: (t) => ref.read(addTaskController).content = t.trim(),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                minLines: 4,
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SaveToScheduleSwitch(),
            Center(
              child: AppElevatedButton(
                foregroundColor: Colors.white,
                text: "Добавить",
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await ref.read(addTaskController).commit();
                    Navigator.pop(context);
                  }
                },
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
