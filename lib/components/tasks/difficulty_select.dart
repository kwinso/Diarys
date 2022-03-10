import 'package:diarys/components/tasks/difficulty_tile.dart';
import 'package:diarys/components/tasks/input_icon.dart';
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InputIcon(Icons.timeline),
        for (var i = 1; i <= 3; i++)
          Expanded(
            // flex: 1,
            child: DifficultyTile(
              label: AppUtils.getDifficultyLabel(i),
              color: AppUtils.getDifficultyColor(i),
              difficulty: i,
              isSelected: i == selected,
              onSelect: () => onSelect(i),
            ),
          ),
      ],
    );
  }
}
