import 'package:diarys/state/add_task.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DifficultySelect extends StatelessWidget {
  final int selected;
  final Function(int) onSelect;
  const DifficultySelect({
    Key? key,
    required this.selected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DifficultySelectLayout(selected: selected),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 1; i <= 3; i++)
              GestureDetector(
                onTap: () => onSelect(i),
                child: Container(height: 55, width: 30, color: Colors.transparent),
              ),
          ],
        )
      ],
    );
  }
}

const double indicatorSize = 18;

class DifficultySelectLayout extends StatelessWidget {
  final int selected;
  const DifficultySelectLayout({
    Key? key,
    required this.selected,
  }) : super(key: key);

  Offset _getIndicatorOffset(double maxWidth, int dif) {
    // Since indicator is moved by edge, we should keep the size of it in percentage to whole slider width
    double padding = indicatorSize / maxWidth;
    double xOffset = 0;

    // In the middle slider should be offset right by half of the indicator size to be in middle
    if (dif == 2) xOffset = 0.5 - padding / 2;
    // On the end slider goes out of it's bounds, it should be offset by indicatorSize to be right on end
    if (dif == 3) xOffset = 1 - padding;

    return Offset(xOffset, 0);
  }

  @override
  Widget build(BuildContext context) {
    // final dif = ref.watch(addTaskController.select((value) => value.difficulty));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 2,
                color: Theme.of(context).primaryColor,
              ),
              LayoutBuilder(
                builder: (context, constraints) => AnimatedSlide(
                  duration: const Duration(milliseconds: 200),
                  offset: _getIndicatorOffset(constraints.maxWidth, selected),
                  child: Row(
                    children: [
                      Container(
                        width: indicatorSize,
                        height: indicatorSize,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          border:
                              Border.all(width: 1, color: AppUtils.getDifficultyColor(selected)),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LineDivider(icon: "😄", selectedDif: selected, ownDif: 1),
              LineDivider(icon: "😓", selectedDif: selected, ownDif: 2),
              LineDivider(icon: "😫", selectedDif: selected, ownDif: 3),
            ],
          ),
        )
      ],
    );
  }
}

class LineDivider extends StatelessWidget {
  final String icon;
  final int selectedDif;
  final int ownDif;
  const LineDivider({
    Key? key,
    required this.icon,
    required this.selectedDif,
    required this.ownDif,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 100),
      opacity: selectedDif == ownDif ? 1 : 0.3,
      child: Column(
        children: [
          Container(
            width: 2,
            height: 15,
            color: Theme.of(context).colorScheme.primaryContainer,
            margin: const EdgeInsets.only(bottom: 5),
          ),
          Text(
            icon,
            style: const TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }
}
