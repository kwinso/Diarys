import 'package:diarys/components/tasks/date_select_dropdown.dart';
import 'package:diarys/components/tasks/field_icon.dart';
import 'package:flutter/material.dart';

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
        const FieldIcon(Icons.date_range),
        Expanded(
          child: Container(
            child: DateSelectDropdown(
              lesson: widget.lesson,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Theme.of(context).colorScheme.primaryContainer),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
