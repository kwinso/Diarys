import 'package:diarys/components/task_card.dart';
import 'package:diarys/state/hive/types/task.dart';
import 'package:flutter/material.dart';

class TasksList extends StatelessWidget {
  final String header;
  final List<Task> tasks;
  const TasksList({
    Key? key,
    required this.header,
    required this.tasks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              header,
              style:
                  TextStyle(fontSize: 25, color: Theme.of(context).colorScheme.tertiaryContainer),
            ),
          ),
          tasks.isNotEmpty
              ? Column(children: [for (var t in tasks) TaskCard(t)])
              : Text(
                  "Пока пусто",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18, color: Theme.of(context).colorScheme.tertiaryContainer),
                ),

          // Task Cards
        ],
      ),
    );
  }
}
