import 'package:diarys/texts.dart';
import 'package:flutter/material.dart';

class ScheduleSwiperControls extends StatefulWidget {
  final Function? onNext;
  final Function? onPrev;
  final ValueNotifier<int> index;

  const ScheduleSwiperControls(
      {required this.index, this.onNext, this.onPrev, Key? key})
      : super(key: key);

  @override
  State<ScheduleSwiperControls> createState() => _ScheduleSwiperControlsState();
}

class _ScheduleSwiperControlsState extends State<ScheduleSwiperControls> {
  void onIndexUpdate() {
    setState(() => {});
  }

  @override
  void initState() {
    widget.index.addListener(onIndexUpdate);
    super.initState();
  }

  @override
  void dispose() {
    widget.index.removeListener(onIndexUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      IconButton(
          splashColor: Colors.transparent,
          onPressed: () => widget.onPrev!(),
          icon: Icon(
            Icons.chevron_left_outlined,
            size: 35,
            color: Theme.of(context).colorScheme.tertiaryContainer,
          )),
      Text(
        AppTexts.week.days[widget.index.value],
        style: TextStyle(
            fontSize: 25,
            color: DateTime.now().weekday - 1 == widget.index.value
                ? Theme.of(context).colorScheme.tertiary
                : Theme.of(context).colorScheme.tertiaryContainer),
      ),
      IconButton(
          onPressed: () => widget.onNext!(),
          icon: Icon(
            Icons.chevron_right_outlined,
            size: 35,
            color: Theme.of(context).colorScheme.tertiaryContainer,
          ))
    ]);
  }
}
