import 'package:diarys/components/elevated_button.dart';
import 'package:diarys/state/hive/types/task.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';

// TODO: Implement editing
class TaskInfo extends StatefulWidget {
  final Task task;
  const TaskInfo(this.task, {Key? key}) : super(key: key);

  @override
  State<TaskInfo> createState() => _TaskInfoState();
}

class _TaskInfoState extends State<TaskInfo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.task.subject,
          style: const TextStyle(fontSize: 30),
        ),
        Text(
          AppUtils.formatDate(widget.task.untilDate),
          style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).colorScheme.tertiaryContainer),
        ),
        Divider(
          thickness: 2,
          // height: 5,
          color: AppUtils.getDifficultyColor(widget.task.difficulty),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 15),
          constraints: const BoxConstraints(minHeight: 50, maxHeight: 100),
          child: TextFormField(
            // initialValue: ref.read(addTaskController).data.content,
            // validator: (v) => v!.isEmpty ? "Домашнее задание обязательно" : null,
            // onChanged: (t) => ref.read(addTaskController).setContent(t.trim()),
            initialValue: widget.task.content,
            maxLines: null,
            textCapitalization: TextCapitalization.sentences,
            // minLines: 4,
            style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        // TODO: Delete button
        // TODO: Mark as done
        AppElevatedButton(
            text: "Сделано",
            onPressed: () {},
            color: Theme.of(context).colorScheme.secondary),
      ],
    );
  }
}
