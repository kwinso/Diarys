import 'package:diarys/state/add_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
        Flexible(
          child: Text(
            "Добавить в расписание",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: CupertinoSwitch(
            value: ref.watch(addTaskController.select((value) => value.saveToSchedule)),
            onChanged: (v) => ref.read(addTaskController).saveToSchedule = v,
            activeColor: Theme.of(context).colorScheme.secondary,
          ),
        )
      ],
    );
  }
}
