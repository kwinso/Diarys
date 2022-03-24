import 'package:diarys/components/tasks/card.dart';
import 'package:diarys/state/hive/types/task.dart';
import 'package:flutter/material.dart';

/// Will not render if [tasks.isEmpty] == [true]
class TasksList extends StatefulWidget {
  final String header;
  final List<Task> tasks;
  const TasksList({
    Key? key,
    required this.header,
    required this.tasks,
  }) : super(key: key);

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  bool _hiding = false;

  @override
  void didUpdateWidget(covariant TasksList oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _hiding = widget.tasks.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: AnimatedCrossFade(
              duration: Duration(milliseconds: 200),
              crossFadeState: !_hiding ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              secondChild: Container(),
              firstChild: Center(
                child: Text(
                  widget.header,
                  style: const TextStyle(fontSize: 25),
                ),
              ),
            ),
          ),
          Column(children: [
            for (var t in widget.tasks)
              TaskCard(
                t,
                key: t.id,
                onDelete: () {
                  if (widget.tasks.length == 1) setState(() => _hiding = true);
                },
              )
          ])
        ],
      ),
    );
  }
}
