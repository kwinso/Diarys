import 'package:diarys/components/tasks/field_label.dart';
import 'package:diarys/state/add_task.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DifficultySelect extends ConsumerWidget {
  final int selected;
  final Function(int) onSelect;
  const DifficultySelect({
    Key? key,
    required this.selected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(addTaskController.select((value) => value.difficulty));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TaskFieldLabel("Сложность"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 1; i <= 3; i++)
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: i == selected ? 1 : 0.5,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: AppUtils.getDifficultyColor(i)),
                    child: GestureDetector(
                      onTap: () => onSelect(i),
                      child: Center(
                          child: Text(
                        AppUtils.getDifficultyEmoji(i),
                        style: const TextStyle(fontSize: 25),
                      )),
                    ),
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }
}
