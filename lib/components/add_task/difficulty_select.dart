import 'package:diarys/components/add_task/difficulty_tile.dart';
import 'package:diarys/components/add_task/label.dart';
import 'package:diarys/state/add_task.dart';
import 'package:diarys/theme/colors.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DifficultySelect extends ConsumerWidget {
  const DifficultySelect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const DifficultySelectLayout(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 1; i <= 3; i++)
              GestureDetector(
                onTap: () => ref.read(addTaskController).difficulty = i,
                child: Opacity(
                    opacity: 0,
                    child: Container(
                      height: 30,
                      width: 30,
                      color: Colors.transparent,
                    )),
              ),
          ],
        )
      ],
    );
  }
}

const double indicatorSize = 18;

class DifficultySelectLayout extends ConsumerWidget {
  const DifficultySelectLayout({
    Key? key,
  }) : super(key: key);

  Offset _getIndicatorOffSet(double maxWidth, int dif) {
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
  Widget build(BuildContext context, ref) {
    final dif = ref.watch(addTaskController.select((value) => value.difficulty));

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
                  offset: _getIndicatorOffSet(constraints.maxWidth, dif),
                  child: Row(
                    children: [
                      Container(
                        width: indicatorSize,
                        height: indicatorSize,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          border: Border.all(width: 1, color: AppUtils.getDifficultyColor(dif)),
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
              LineDivider(icon: "😄", selectedDif: dif, ownDif: 1),
              LineDivider(icon: "😓", selectedDif: dif, ownDif: 2),
              LineDivider(icon: "😫", selectedDif: dif, ownDif: 3),
            ],
          ),
        )
      ],
    );
  }
}

class LineDivider extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 100),
      opacity: selectedDif == ownDif ? 1 : 0.3,
      child: GestureDetector(
        onTap: () => ref.read(addTaskController).difficulty = ownDif,
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
      ),
    );
  }
}
