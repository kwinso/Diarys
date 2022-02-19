import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ScheduleLesson extends StatefulWidget {
  String name;
  int index;
  ScheduleLesson({required this.name, required this.index, Key? key}) : super(key: key);

  @override
  State<ScheduleLesson> createState() => _ScheduleLessonState();
}

class _ScheduleLessonState extends State<ScheduleLesson> {
  bool isTappedDown = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // TODO:
      onTap: () {
        showMaterialModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Theme.of(context).primaryColor,
          builder: (context) => Container(
              padding: const EdgeInsets.all(15), child: const Text("Placeholder, I think...")),
        );
      },
      child: Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.all(Radius.circular(12))),
          // color:
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                (widget.index + 1).toString(),
                style: const TextStyle(fontSize: 20),
              ),
              Expanded(
                  child: Center(child: Text(widget.name, style: const TextStyle(fontSize: 20))))
            ],
          )),
    );
  }
}
