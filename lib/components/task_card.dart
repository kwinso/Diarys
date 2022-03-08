import 'package:diarys/state/hive_types/task.dart';
import 'package:diarys/theme/colors.dart';
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
    _controller = AnimationController(duration: const Duration(milliseconds: 100), vsync: this);
    _animation =
        ColorTween(begin: Colors.transparent, end: _getDifficultyColor(widget.task.difficulty))
            .animate(_controller);
  }

  Color _getDifficultyColor(int d) {
    switch (d) {
      case 1:
        return AppColors.green;
      case 2:
        return AppColors.yellow;
      // 3 and (somehow) more (bc 3 is the max)
      default:
        return AppColors.red;
    }
  }

  String _safeTextContent(String t) {
    return t.length > 30 ? t.characters.take(30).toString() + "..." : t;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Text(
                _safeTextContent(widget.task.textContent),
                style: TextStyle(color: Theme.of(context).colorScheme.tertiaryContainer),
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
              setState(() {
                _done = !_done;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: _animation.value,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(width: 1, color: _getDifficultyColor(widget.task.difficulty))),
              alignment: Alignment.center,
              child: Icon(Icons.done, size: 20, color: Theme.of(context).colorScheme.tertiary),
            ),
          )
        ],
      ),
    );
  }
}
