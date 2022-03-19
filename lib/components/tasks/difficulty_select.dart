import 'package:diarys/components/tasks/difficulty_tile.dart';
import 'package:diarys/state/add_task.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskDifficultySelect extends ConsumerWidget {
  const TaskDifficultySelect({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final dif = ref.watch(addTaskController).data.difficulty;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 1; i <= 3; i++)
          Expanded(
            // flex: 1,
            child: DifficultyTile(
                label: AppUtils.getDifficultyLabel(i),
                color: AppUtils.getDifficultyColor(i),
                difficulty: i,
                isSelected: i == dif,
                onSelect: () => ref.read(addTaskController).setDifficulty(i)),
          ),
      ],
    );
  }
}
