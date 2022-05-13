import 'dart:async';
import 'package:diarys/components/tasks/edit/info.dart';
import 'package:diarys/screens/task_info.dart';
import 'package:diarys/state/edit_task.dart';
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
  late AnimationController _controller;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
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

    Timer(const Duration(milliseconds: 300), () {
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
          Navigator.push(context, MaterialPageRoute(builder: (ctx) => TaskInfoPage(widget.task)));
          // AppUtils.showBottomSheet(
          //   key: widget.task.id,
          //   context: context,
          //   builder: (context) {
          // ref.read(taskEditController).update(widget.task);
          // return Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 5),
          //   child: TaskInfo(
          //     widget.task.id,
          //     onSetDone: _setDone,
          //   ),
          // );
          // },
          // );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: Theme.of(context).primaryColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _CardInfo(task: widget.task)),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(children: [
                  IconButton(
                    onPressed: () => _setDone(),
                    icon: Icon(
                      Icons.done_rounded,
                      color: Theme.of(context).colorScheme.primaryContainer,
                      size: 30,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    size: 30,
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _CardInfo extends StatelessWidget {
  final Task task;
  const _CardInfo({Key? key, required this.task}) : super(key: key);

  String _withoutWhitespaces(String t) {
    return t.replaceAll(RegExp(r'\s'), " ");
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            color: AppUtils.getDifficultyColor(task.difficulty),
            shape: BoxShape.circle,
          ),
          child: Text(AppUtils.getDifficultyEmoji(task.difficulty)),
        ),
        Expanded(
          child: Column(
            textDirection: TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _withoutWhitespaces(task.subject),
                style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.tertiary),
                softWrap: false,
                overflow: TextOverflow.fade,
              ),
              Visibility(
                visible: task.content.isNotEmpty,
                child: Text(
                  _withoutWhitespaces(task.content),
                  style: TextStyle(
                      fontSize: 15, color: Theme.of(context).colorScheme.tertiaryContainer),
                  softWrap: false,
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
