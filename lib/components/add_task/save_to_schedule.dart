import 'package:diarys/state/add_task.dart';
import 'package:diarys/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class SaveToScheduleSwitch extends ConsumerWidget {
  const SaveToScheduleSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(addTaskController.select((v) => v.subject));
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: !ref.read(addTaskController).subjectInSchedule ? const _Switch() : Container(),
    );
  }
}

class _Switch extends ConsumerWidget {
  const _Switch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
        ),
        const Flexible(child: Text("Добавить в расписание")),
        Switch(
          value: ref.watch(addTaskController.select((value) => value.saveToSchedule)),
          onChanged: (v) => ref.read(addTaskController).saveToSchedule = v,
          activeColor: Theme.of(context).colorScheme.secondary,
        ),
      ],
    );
  }
}
