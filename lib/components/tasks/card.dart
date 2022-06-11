import 'dart:async';
import 'package:diarys/screens/task_info.dart';
import 'package:diarys/state/hive/controllers/tasks.dart';
import 'package:diarys/state/hive/types/task.dart';
import 'package:diarys/theme/colors.dart';
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
  bool _done = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _markDone() {
    setState(() {
      _done = true;
    });
    widget.onDelete();

    Timer(const Duration(milliseconds: 350), () {
      ref.read(tasksController).remove(widget.task.id);
      // TODO: implement when archiving is done
      //   AppUtils.showSnackBar(context,
      //       text: "Задание выполнено.",
      //       action: SnackBarAction(
      //         label: "Отменить",
      //         textColor: Theme.of(context).colorScheme.secondary,
      //         onPressed: () {},
      //       ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 300),
      crossFadeState: _done ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      secondChild: Container(),
      firstChild: GestureDetector(
        key: widget.key,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (ctx) => TaskInfoPage(widget.task)));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            border: Border.all(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5), width: 1),
            color: Theme.of(context).primaryColor,
          ),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              // LayoutBuilder(builder: (context, constrains) {
              //   return SizedBox(
              //     height: constrains.maxHeight,
              //     child: Container(
              //       // constraints: BoxConstraints({...constrains}),
              //       color: AppColors.red,
              //       child: Center(child: Icon(Icons.warning_amber_rounded)),
              //     ),
              //   );
              // }),
              // Column(children: [
              //   Container(
              //     // constraints: BoxConstraints.expand(),
              //     // constraints: BoxConstraints({...constrains}),
              //     // height: double.infinity,
              //     decoration:
              //         BoxDecoration(color: AppColors.red, border: Border.all(color: AppColors.red)),
              //     child: Center(child: Icon(Icons.warning_amber_rounded)),
              //   ),
              // ]),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: _CardInfo(task: widget.task, onDone: _markDone),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardInfo extends StatelessWidget {
  final Task task;
  final VoidCallback onDone;
  const _CardInfo({Key? key, required this.task, required this.onDone}) : super(key: key);

  String _withoutWhitespaces(String t) {
    return t.replaceAll(RegExp(r'\s'), " ");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _withoutWhitespaces(task.subject),
              style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.tertiary),
              softWrap: false,
              overflow: TextOverflow.fade,
            ),
            Container(
              padding: const EdgeInsets.all(3),
              margin: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: AppUtils.getDifficultyColor(task.difficulty)),
                  color: Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.2)),
              child: Text(
                AppUtils.getDifficultyEmoji(task.difficulty),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 9),
              ),
            ),
          ],
        ),
        Visibility(
          visible: task.content.isNotEmpty,
          child: Padding(
            padding: EdgeInsets.only(top: 1),
            child: Text(
              _withoutWhitespaces(task.content),
              style:
                  TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.tertiaryContainer),
              softWrap: false,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                AppUtils.formatDate(task.untilDate),
                style: TextStyle(
                  fontSize: 9,
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  // color: AppColors.red,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  // color: AppColors.red,
                  color: Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.2),
                ),
              ),
            ),
            // GestureDetector(
            //   onTap: onDone,
            //   child: Container(
            //     child: Icon(Icons.done_outlined,
            //         color: Theme.of(context).colorScheme.tertiaryContainer),
            //     padding: EdgeInsets.symmetric(vertical: 4),
            //     // decoration: BoxDecoration(
            //     // borderRadius: BorderRadius.circular(5),
            //     // border: Border.all(color: AppColors.green),
            //     // color: Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.2)),
            //     // ),
            //     // child: Text(
            //     //   "Завершить",
            //     //   style: TextStyle(
            //     //     fontSize: 9,
            //     //     color: Theme.of(context).colorScheme.tertiaryContainer,
            //     //   ),
            //     // ),
            //   ),
            // ),
          ],
        )
      ],
    );
  }
}
