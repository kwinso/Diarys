import 'package:diarys/components/tasks/difficulty_tile.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';

class TaskDifficultySelect extends StatelessWidget {
  final int selected;
  final Function(int select) onSelect;

  const TaskDifficultySelect({
    Key? key,
    required this.selected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var i = 1; i <= 3; i++)
            DifficultyTile(
              label: AppUtils.getDifficultyLabel(i),
              color: AppUtils.getDifficultyColor(i),
              difficulty: i,
              isSelected: i == selected,
              onSelect: () => onSelect(i),
            ),
        ],
      ),
    );
  }
}
