import 'package:diarys/components/tasks/card.dart';
import 'package:diarys/state/hive/controllers/tasks.dart';
import 'package:diarys/state/hive/types/task.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Will not render if [tasks.isEmpty] == [true]
class TasksList extends ConsumerStatefulWidget {
  final String title;
  final List<Task> tasks;
  final String? dateLabel;
  const TasksList({
    Key? key,
    required this.title,
    required this.tasks,
    this.dateLabel,
  }) : super(key: key);

  @override
  ConsumerState<TasksList> createState() => _TasksListState();
}

class _TasksListState extends ConsumerState<TasksList> {
  bool _titleHidden = false;
  final _key = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _titleHidden = widget.tasks.isEmpty;
  }

  @override
  void didUpdateWidget(covariant TasksList oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _titleHidden = widget.tasks.isEmpty;
    });
  }

  Widget _getHeader() {
    final nameLabel = Text(
      widget.title,
      style: TextStyle(fontSize: 23, color: Theme.of(context).colorScheme.tertiaryContainer),
    );
    // if (widget.dateLabel != null) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        nameLabel,
        Text(
          widget.dateLabel ?? "",
          style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.primaryContainer),
        )
      ],
    );
    // }

    // return Center(child: nameLabel);
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
            crossFadeState: !_titleHidden ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            secondChild: Container(),
            firstChild: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: _getHeader(),
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
                    if (widget.tasks.length == 1) setState(() => _titleHidden = true);
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
