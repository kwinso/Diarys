import 'package:flutter/material.dart';

// TODO: Dynamic index
class ScheduleSwiperControls extends StatefulWidget {
  final ValueChanged<int>? onStep;
  ScheduleSwiperControls({
    this.onStep,
    Key? key,
  }) : super(key: key);

  @override
  State<ScheduleSwiperControls> createState() => _ScheduleSwiperControlsState();
}

class _ScheduleSwiperControlsState extends State<ScheduleSwiperControls> {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      IconButton(
          onPressed: () => widget.onStep!(-1),
          icon: Icon(
            Icons.chevron_left,
            size: 35,
            color: Theme.of(context).colorScheme.tertiaryContainer,
          )),
      Text("Понедельник",
          style: TextStyle(
              fontSize: 20, color: Theme.of(context).colorScheme.tertiary)),
      IconButton(
          onPressed: () => widget.onStep!(1),
          icon: Icon(
            Icons.chevron_right,
            size: 35,
            color: Theme.of(context).colorScheme.tertiaryContainer,
          ))
    ]);
  }
}
