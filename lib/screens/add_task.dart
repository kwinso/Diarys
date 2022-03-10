import 'package:diarys/components/route_bar.dart';
import 'package:diarys/components/tasks/date_select.dart';
import 'package:diarys/components/tasks/difficulty_select.dart';
import 'package:diarys/components/tasks/name_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTask extends ConsumerStatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends ConsumerState<AddTask> {
  String _lesson = "";
  String _taskContents = "";
  // 0 is default so nothing is selected
  int _difficulty = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: const RouteBar(
        name: "Новое ДЗ",
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            children: [
              TaskNameInput(
                onStopTyping: (s) => setState(() => _lesson = s),
              ),
              TaskDateSelect(
                lesson: _lesson,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                child: TaskDifficultySelect(
                  selected: _difficulty,
                  onSelect: (d) => setState(() => _difficulty = d),
                ),
              ),
              Container(
                constraints: const BoxConstraints(maxHeight: 100),
                child: TextField(
                  onChanged: (t) => setState(() => _taskContents = t),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  minLines: 4,
                  style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: "Домашнее задание",
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.tertiaryContainer),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
