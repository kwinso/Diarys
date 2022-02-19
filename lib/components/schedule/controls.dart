import 'package:diarys/texts.dart';
import 'package:flutter/material.dart';

// TODO: Dynamic index

class ScheduleSwiperControls extends StatefulWidget {
  final Function? onNext;
  final Function? onPrev;
  final int index;

  const ScheduleSwiperControls(
      {this.index = 0, this.onNext, this.onPrev, Key? key})
      : super(key: key);

  @override
  State<ScheduleSwiperControls> createState() => _ScheduleSwiperControlsState();
}

class _ScheduleSwiperControlsState extends State<ScheduleSwiperControls> {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      IconButton(
          onPressed: () => widget.onPrev!(),
          icon: Icon(
            Icons.chevron_left,
            size: 35,
            color: Theme.of(context).colorScheme.tertiaryContainer,
          )),
      Text(AppTexts.week.days[widget.index],
          style: TextStyle(
              fontSize: 20, color: Theme.of(context).colorScheme.tertiary)),
      IconButton(
          onPressed: () => widget.onNext!(),
          icon: Icon(
            Icons.chevron_right,
            size: 35,
            color: Theme.of(context).colorScheme.tertiaryContainer,
          ))
    ]);
  }
}
