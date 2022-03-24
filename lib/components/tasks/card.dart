import 'package:diarys/components/tasks/info.dart';
import 'package:diarys/state/hive/types/task.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  const TaskCard(
    this.task, {
    Key? key,
  }) : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> with SingleTickerProviderStateMixin {
  late Animation<Color?> _animation;
  late AnimationController _controller;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _animation = ColorTween(
            begin: Colors.transparent, end: AppUtils.getDifficultyColor(widget.task.difficulty))
        .animate(_controller)
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppUtils.showBottomSheet(
            context: context,
            builder: (context) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: TaskInfo(widget.task),
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
              onTap: () {
                if (_done) {
                  _controller.reverse();
                } else {
                  _controller.forward();
                }
                _done = !_done;
              },
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
    );
  }
}
