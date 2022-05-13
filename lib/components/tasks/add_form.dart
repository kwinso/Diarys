import 'package:diarys/components/tasks/date_dropdown.dart';
import 'package:diarys/components/tasks/difficulty_select.dart';
import 'package:diarys/components/tasks/field_label.dart';
import 'package:diarys/components/tasks/save_to_schedule.dart';
import 'package:diarys/components/tasks/subject_input.dart';
import 'package:diarys/components/tasks/task_text_input.dart';
import 'package:diarys/state/add_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormHeader extends ConsumerWidget {
  const FormHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SubjectInput(),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: DateSelectDropdown(),
          ),
          DifficultySelect(
            selected: ref.watch(addTaskController.select((value) => value.difficulty)),
            onSelect: (d) => ref.read(addTaskController).difficulty = d,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: SaveToScheduleSwitch(),
          ),
        ]));
  }
}

// TODO: Add files list
class OptionalFormFields extends ConsumerWidget {
  const OptionalFormFields({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TaskFieldLabel("Задание"),
          TaskTextInput(
            controller: addTaskController,
          ),
        ],
      ),
    );
  }
}
