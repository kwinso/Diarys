import 'package:diarys/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ScheduleLesson extends StatefulWidget {
  final String name;
  final bool isSelected;
  final bool inEditMode;
  final int index;
  final Function(int index) onToggleSelection;
  ScheduleLesson(
      {required this.name,
      required this.isSelected,
      required this.inEditMode,
      required this.index,
      required this.onToggleSelection,
      Key? key})
      : super(key: key);

  @override
  State<ScheduleLesson> createState() => _ScheduleLessonState();
}

class _ScheduleLessonState extends State<ScheduleLesson> {
  Color _getBGColor() {
    return widget.inEditMode && widget.isSelected
        ? Theme.of(context).colorScheme.primaryContainer
        : Theme.of(context).primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.inEditMode) {
          widget.onToggleSelection(widget.index);
          return;
        }
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
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: _getBGColor(),
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
                  child: Center(child: Text(widget.name, style: const TextStyle(fontSize: 20)))),
              widget.inEditMode ? const Icon(Icons.drag_handle) : Container()
            ],
          )),
    );
  }
}
