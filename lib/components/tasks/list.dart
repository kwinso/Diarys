import 'package:diarys/components/tasks/card.dart';
import 'package:diarys/state/hive/types/task.dart';
import 'package:flutter/material.dart';

/// Will not render if [tasks.isEmpty] == [true]
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
    // if (tasks.isEmpty) return Container();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: AnimatedCrossFade(
              duration: Duration(milliseconds: 200),
              crossFadeState:
                  tasks.isNotEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              secondChild: Container(),
              firstChild: Center(
                child: Text(
                  header,
                  style: const TextStyle(fontSize: 25),
                ),
              ),
            ),
          ),
          Column(children: [for (var t in tasks) TaskCard(t, key: t.id)])
        ],
      ),
    );
  }
}
