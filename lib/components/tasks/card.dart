import 'dart:async';

import 'package:diarys/components/tasks/info.dart';
import 'package:diarys/state/add_task.dart';
import 'package:diarys/state/hive/controllers/tasks.dart';
import 'package:diarys/state/hive/types/task.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskCard extends ConsumerStatefulWidget {
  final Task task;
  final VoidCallback onDelete;
  const TaskCard(this.task, {Key? key, required this.onDelete}) : super(key: key);

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends ConsumerState<TaskCard> with SingleTickerProviderStateMixin {
  late Animation<Color?> _animation;
  late AnimationController _controller;
  bool _done = false;
  bool _rendered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _animation = ColorTween(
            begin: Colors.transparent, end: AppUtils.getDifficultyColor(widget.task.difficulty))
        .animate(_controller)
      ..addListener(() => setState(() {}));

    Timer(Duration.zero, () => setState(() => _rendered = true));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setDone() {
    _controller.forward();
    _done = true;
    widget.onDelete();

    Timer(Duration(milliseconds: 300), () {
      ref.read(tasksController).remove(widget.task.id);

      AppUtils.showSnackBar(context,
          text: "Задание выполнено.",
          action: SnackBarAction(
            label: "Отменить",
            textColor: Theme.of(context).colorScheme.secondary,
            // TODO
            onPressed: () {},
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 300),
      crossFadeState: _done ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      secondChild: Container(),
      firstChild: GestureDetector(
        onTap: () {
          AppUtils.showBottomSheet(
              context: context,
              builder: (context) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: TaskInfo(
                      widget.task,
                      onBeforeDone: _setDone,
                    ),
                  ));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: Theme.of(context).primaryColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 5),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                  child: Text(
                    widget.task.subject,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              GestureDetector(
                // TODO: Remove task after timeout because "done"  is tapped
                onTap: _setDone,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: _animation.value,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                          width: 1, color: AppUtils.getDifficultyColor(widget.task.difficulty))),
                  alignment: Alignment.center,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _done ? 1 : 0,
                    child: const Icon(Icons.done, size: 16, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
