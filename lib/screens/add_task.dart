import 'package:diarys/components/route_bar.dart';
import 'package:diarys/components/tasks/date_select.dart';
import 'package:diarys/components/tasks/difficulty_select.dart';
import 'package:diarys/components/tasks/subject_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTask extends ConsumerStatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends ConsumerState<AddTask> {
  String _subject = "";
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
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TaskSubjectInput(
                onStopTyping: (s) => setState(() => _subject = s),
              ),
              TaskDateSelect(),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Сложность",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              TaskDifficultySelect(
                selected: _difficulty,
                onSelect: (d) => setState(() => _difficulty = d),
              ),
              Container(
                constraints: const BoxConstraints(maxHeight: 100),
                child: TextField(
                  onChanged: (t) => setState(() => _taskContents = t),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  minLines: 4,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: "Домашнее задание",
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
