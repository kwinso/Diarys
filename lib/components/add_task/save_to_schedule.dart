import 'package:diarys/state/add_task.dart';
import 'package:diarys/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class SaveToScheduleCheckBox extends ConsumerStatefulWidget {
  const SaveToScheduleCheckBox({Key? key}) : super(key: key);

  @override
  _SaveToScheduleCheckBoxState createState() => _SaveToScheduleCheckBoxState();
}

class _SaveToScheduleCheckBoxState extends ConsumerState<SaveToScheduleCheckBox> {
  @override
  Widget build(BuildContext context) {
    final addTask = ref.watch(addTaskController);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Checkbox(
          // TODO: Change with value form settings
          activeColor: Theme.of(context).colorScheme.secondary,
          value: addTask.saveToSchedule,
          onChanged: (v) => addTask.saveToSchedule = v,
        ),
        const Flexible(child: Text("Добавить в расписание")),
        GestureDetector(
          onTap: () {
            AppUtils.showSnackBar(
              context,
              text: "Добавит выбранный предмет в расписание",
              action: SnackBarAction(
                textColor: Theme.of(context).colorScheme.secondary,
                label: "Изменить",
                // TODO: Navigate to settings
                onPressed: () {},
              ),
            );
          },
          child: Icon(
            Icons.info_outline,
            color: Theme.of(context).colorScheme.tertiaryContainer,
          ),
        )
      ],
    );
  }
}
