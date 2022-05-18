import 'package:diarys/components/schedule/modal_form.dart';
import 'package:diarys/components/schedule/modal_input.dart';
import 'package:diarys/state/edit_schedule.dart';
import 'package:diarys/state/hive/controllers/schedule.dart';
import 'package:diarys/theme/colors.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleLesson extends ConsumerStatefulWidget {
  final String name;
  final bool isSelected;
  final bool inEditMode;
  final int day;
  final int index;
  final Function(int day, int index) onToggleSelection;

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

  Widget _getIcon() {
    if (widget.inEditMode && widget.isSelected) {
      return Icon(Icons.clear_rounded, color: Colors.white);
    }

    return Text(
      (widget.index + 1).toString(),
      style: const TextStyle(fontSize: 18, color: Colors.white),
    );
  }

  Color _getIconBGColor() {
    return widget.inEditMode && widget.isSelected ? AppColors.red : AppColors.blue;
  }

  @override
  Widget build(BuildContext context) {
    final editMode = ref.read(scheduleEditController);
    return GestureDetector(
      onLongPress: () {
        if (!editMode.active) {
          editMode.active = !editMode.active;
          widget.onToggleSelection(widget.day, widget.index);
        }
      },
      onTap: () {
        if (widget.inEditMode) {
          widget.onToggleSelection(widget.day, widget.index);
          return;
        }
        AppUtils.showBottomSheet(
          context: context,
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
                    .read(scheduleController)
                    .updateLessosNameInDay(widget.day, widget.index, _newName);
              }
              Navigator.pop(context);
            },
          ),
        );
      },
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(12))),
          child: Row(
            children: [
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(color: _getIconBGColor(), shape: BoxShape.circle),
                child: Center(
                  child: AnimatedCrossFade(
                    crossFadeState: widget.inEditMode && widget.isSelected
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: Duration(
                      milliseconds: 200,
                    ),
                    firstChild: Text(
                      (widget.index + 1).toString(),
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    secondChild: Icon(Icons.clear_rounded, color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  widget.name,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(fontSize: 20),
                ),
              )),
              ReorderableDragStartListener(
                  child: Icon(
                    Icons.drag_handle,
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  index: widget.index),
            ],
          )),
    );
  }
}
