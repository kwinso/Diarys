import 'package:diarys/components/schedule/modal_form.dart';
import 'package:diarys/components/schedule/modal_input.dart';
import 'package:diarys/state/schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ScheduleLesson extends ConsumerStatefulWidget {
  final String name;
  final bool isSelected;
  final bool inEditMode;
  final int day;
  final int index;
  final Function(int index) onToggleSelection;

  const ScheduleLesson(
      {required this.name,
      required this.day,
      required this.isSelected,
      required this.inEditMode,
      required this.index,
      required this.onToggleSelection,
      Key? key})
      : super(key: key);

  @override
  _ScheduleLessonState createState() => _ScheduleLessonState();
}

class _ScheduleLessonState extends ConsumerState<ScheduleLesson> {
  String _newName = "";

  @override
  void initState() {
    super.initState();
    _newName = widget.name;
  }

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
            backgroundColor: Theme.of(context).backgroundColor,
            builder: (context) => ModalForm(
                input: ModalAutoCompleteInput(
                  multiline: false,
                  value: _newName,
                  onTextUpdate: (t) {
                    setState(() {
                      _newName = t;
                    });
                  },
                ),
                onCancel: () {
                  Navigator.pop(context);
                },
                submitButtonText: "Сохранить",
                onSubmit: () {
                  if (_newName.isNotEmpty) {
                    ref
                        .read(scheduleState.notifier)
                        .updateLessosNameInDay(widget.day, widget.index, _newName);
                  }
                  Navigator.pop(context);
                }));
      },
      child: Container(
          height: 50,
          margin: const EdgeInsets.all(5),
          // padding: const EdgeInsets.symmetric(horizontal: 20),
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
              widget.inEditMode
                  ? Icon(
                      Icons.drag_handle,
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                    )
                  : Container()
            ],
          )),
    );
  }
}
