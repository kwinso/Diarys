import 'dart:async';

import 'package:diarys/components/add_task/calendar.dart';
import 'package:diarys/components/add_task/difficulty_select.dart';
import 'package:diarys/components/elevated_button.dart';
import 'package:diarys/state/hive/controllers/tasks.dart';
import 'package:diarys/state/hive/types/task.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskInfo extends ConsumerStatefulWidget {
  final Task task;
  final VoidCallback onBeforeDone;
  const TaskInfo(
    this.task, {
    Key? key,
    required this.onBeforeDone,
  }) : super(key: key);

  @override
  _TaskInfoState createState() => _TaskInfoState();
}

// TODO: 1. Split every elemnt to own widget
// TODO: 2. Add suggestions when typing subject
// TODO: 3. Detatch DifficultySelect from addTaskController
// TODO: 4. Update button at the button from "done" to "save" and backwards when data is updated

class _TaskInfoState extends ConsumerState<TaskInfo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: TextFormField(
                initialValue: widget.task.subject,
                maxLines: 1,
                decoration: const InputDecoration(border: InputBorder.none),
                //  widget.task.subject,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            AppElevatedButton(
              text: AppUtils.formatDate(widget.task.untilDate),
              // TODO: Add "save"  button for calendar. Update arguments for proper work of calendar
              onPressed: () {
                AppUtils.showBottomSheet(
                  context: context,
                  builder: (_) => AppCalendarDatePicker(
                    allowedDays: [],
                    selected: DateTime.now(),
                    onSelect: (_) {},
                  ),
                );
                // showPop
              },
            ),
          ]),
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
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: DifficultySelect(),
        ),
        // TODO: Mark as done
        AppElevatedButton(
          foregroundColor: Colors.white,
          text: "Сделано",
          onPressed: () {
            widget.onBeforeDone();
            Navigator.pop(context);
            Timer(Duration(milliseconds: 400), () {
              ref.read(tasksController).remove(widget.task.id);
            });
          },
          color: Theme.of(context).colorScheme.secondary,
        ),
      ],
    );
  }
}
