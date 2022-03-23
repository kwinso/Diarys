import 'package:diarys/components/add_task/date_dropdown.dart';
import 'package:diarys/components/add_task/difficulty_select.dart';
import 'package:diarys/components/add_task/label.dart';
import 'package:diarys/components/add_task/save_to_schedule.dart';
import 'package:diarys/components/add_task/subject_input.dart';
import 'package:diarys/components/elevated_button.dart';
import 'package:diarys/state/add_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTaskForm extends ConsumerWidget {
  AddTaskForm({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addTask = ref.watch(addTaskController);
    return Form(
      key: formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          children: [
            const SubjectInput(),
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: DateSelectDropdown(),
            ),
            const AddTaskLabel("Укажите сложность: "),
            const DifficultySelect(),
            const AddTaskLabel("Введите текст задания: "),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              constraints: const BoxConstraints(minHeight: 50, maxHeight: 100),
              child: TextFormField(
                initialValue: addTask.data.content,
                validator: (v) => v!.isEmpty ? "Домашнее задание обязательно" : null,
                onChanged: (t) => ref.read(addTaskController).setContent(t.trim()),
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
            AnimatedSize(
              duration: const Duration(milliseconds: 350),
              child: !addTask.subjectInSchedule ? const SaveToScheduleCheckBox() : Container(),
            ),
            AppElevatedButton(
              text: "Добавить",
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await ref.read(addTaskController).commit();
                  Navigator.pop(context);
                }
              },
              color: Theme.of(context).colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
