import 'package:diarys/components/add_task/difficulty_tile.dart';
import 'package:diarys/state/add_task.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskDifficultySelect extends ConsumerWidget {
  final int selected;
  const TaskDifficultySelect({
    Key? key,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var i = 1; i <= 3; i++)
            Expanded(
              // flex: 1,
              child: DifficultyTile(
                  label: AppUtils.getDifficultyLabel(i),
                  color: AppUtils.getDifficultyColor(i),
                  difficulty: i,
                  isSelected: i == selected,
                  onSelect: () => ref.read(addTaskController).setDifficulty(i)),
            ),
        ],
      ),
    );
  }
}
