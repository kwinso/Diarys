import 'package:diarys/state/hive/types/task.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';

class TaskInfo extends StatelessWidget {
  final Task task;
  const TaskInfo(this.task, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            task.subject,
            style: TextStyle(fontSize: 20),
          ),
          Text(
            AppUtils.formatDate(task.untilDate),
            style: TextStyle(fontSize: 20),
          ),
          Text(
            task.content,
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
