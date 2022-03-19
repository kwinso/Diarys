import 'package:diarys/components/route_bar.dart';
import 'package:diarys/components/tasks/date_select.dart';
import 'package:diarys/components/tasks/difficulty_select.dart';
import 'package:diarys/components/tasks/subject_input.dart';
import 'package:diarys/state/add_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTask extends ConsumerStatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends ConsumerState<AddTask> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            ref.read(addTaskController).commit();
            Navigator.pop(context);
          }
        },
        child: const Icon(Icons.done),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: const RouteBar(
        name: "Новое задание",
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              children: [
                const SubjectInput(),
                const TaskDateSelect(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  child: TaskDifficultySelect(),
                ),
                Container(
                  constraints: const BoxConstraints(minHeight: 50, maxHeight: 100),
                  child: TextFormField(
                    validator: (v) => v!.isEmpty ? "Домашнее задание обязательно" : null,
                    onChanged: (t) => ref.read(addTaskController).setTask(t),
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
        ),
      ),
    );
  }

  @override
  void deactivate() {
    ref.read(addTaskController).clear();
    super.deactivate();
  }
}
