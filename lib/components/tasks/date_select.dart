import 'package:diarys/components/tasks/date_select_dropdown.dart';
import 'package:diarys/components/tasks/input_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskDateSelect extends StatefulWidget {
  final String lesson;
  const TaskDateSelect({
    Key? key,
    required this.lesson,
  }) : super(key: key);

  @override
  _TaskDateSelectState createState() => _TaskDateSelectState();
}

class _TaskDateSelectState extends State<TaskDateSelect> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InputIcon(Icons.date_range),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Theme.of(context).colorScheme.primaryContainer),
              ),
            ),
            child: DateSelectDropdown(
              lesson: widget.lesson,
            ),
          ),
        ),
      ],
    );
  }
}
