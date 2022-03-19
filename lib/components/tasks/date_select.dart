import 'package:diarys/components/tasks/date_select_dropdown.dart';
import 'package:diarys/state/add_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskDateSelect extends ConsumerWidget {
  const TaskDateSelect({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: Container(
            child: DateSelectDropdown(
              subject: ref.watch(addTaskController).data.subject,
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
