import 'package:diarys/components/tasks/info.dart';
import 'package:diarys/state/hive/types/task.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
        AppUtils.showBottomSheet(context: context, builder: (context) => TaskInfo(widget.task));
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    widget.task.subject,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            GestureDetector(
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
