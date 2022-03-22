import 'package:diarys/components/add_task/date_select.dart';
import 'package:diarys/components/add_task/difficulty_select.dart';
import 'package:diarys/components/add_task/save_to_schedule.dart';
import 'package:diarys/components/add_task/subject_input.dart';
import 'package:diarys/state/add_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTaskForm extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  const AddTaskForm({Key? key, required this.formKey}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      key: formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          children: [
            const SubjectInput(),
            AnimatedSize(
                duration: const Duration(milliseconds: 350),
                child: !ref.watch(addTaskController).subjectInSchedule
                    ? const SaveToScheduleCheckBox()
                    : Container(),),
            const TaskDateSelect(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
              child: TaskDifficultySelect(),
            ),
            Container(
              constraints: const BoxConstraints(minHeight: 50, maxHeight: 100),
              child: TextFormField(
                initialValue: ref.read(addTaskController).data.content,
                validator: (v) => v!.isEmpty ? "Домашнее задание обязательно" : null,
                onChanged: (t) => ref.read(addTaskController).setContent(t.trim()),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                minLines: 4,
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: "Домашнее задание",
                  alignLabelWithHint: true,
                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.tertiaryContainer),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
