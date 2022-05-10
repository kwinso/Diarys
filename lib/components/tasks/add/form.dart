import 'package:diarys/components/tasks/add/date_dropdown.dart';
import 'package:diarys/components/tasks/add/difficulty_select.dart';
import 'package:diarys/components/tasks/add/label.dart';
import 'package:diarys/components/tasks/add/save_to_schedule.dart';
import 'package:diarys/components/tasks/add/subject_input.dart';
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
          const AddTaskLabel("Сложность"),
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
          const AddTaskLabel("Задание"),
          TextFormField(
            initialValue: ref.read(addTaskController).content,
            onChanged: (t) => ref.read(addTaskController).content = t.trim(),
            maxLines: null,
            textCapitalization: TextCapitalization.sentences,
            minLines: 3,
            style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              hintText: "Мне задали...",
              hintStyle: TextStyle(color: Theme.of(context).colorScheme.primaryContainer),
              filled: true,
              fillColor: Theme.of(context).primaryColor,
              border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
