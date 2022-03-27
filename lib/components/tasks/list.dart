import 'package:diarys/components/tasks/card.dart';
import 'package:diarys/state/hive/controllers/tasks.dart';
import 'package:diarys/state/hive/types/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Will not render if [tasks.isEmpty] == [true]
class TasksList extends ConsumerStatefulWidget {
  final String header;
  final List<Task> tasks;
  const TasksList({
    Key? key,
    required this.header,
    required this.tasks,
  }) : super(key: key);

  @override
  ConsumerState<TasksList> createState() => _TasksListState();
}

class _TasksListState extends ConsumerState<TasksList> {
  bool _hidden = false;
  final _key = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _hidden = widget.tasks.isEmpty;
  }

  @override
  void didUpdateWidget(covariant TasksList oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _hidden = widget.tasks.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(tasksController);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedCrossFade(
            duration: Duration(milliseconds: 200),
            crossFadeState: !_hidden ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            secondChild: Container(),
            firstChild: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(
                  widget.header,
                  style: const TextStyle(fontSize: 25),
                ),
              ),
            ),
          ),
          ListView(
            physics: NeverScrollableScrollPhysics(),
            key: _key,
            shrinkWrap: true,
            children: [
              for (var t in widget.tasks)
                TaskCard(
                  t,
                  key: t.id,
                  onDelete: () {
                    if (widget.tasks.length == 1) setState(() => _hidden = true);
                  },
                )
            ],
          ),
          // Column(children: [
          //   for (var t in widget.tasks)
          //     TaskCard(
          //       t,
          //       key: t.id,
          //     )
          // ])
        ],
      ),
    );
  }
}
