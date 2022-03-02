import 'package:diarys/components/schedule/modal_form.dart';
import 'package:diarys/components/schedule/modal_input.dart';
import 'package:diarys/state/schedule.dart';
import 'package:diarys/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ScheduleFAB extends ConsumerStatefulWidget {
  final int day;
  final bool inEditMode;
  final int selectedItemsCount;
  final VoidCallback onInEditModePressed;
  final VoidCallback onEnterEditMode;

  const ScheduleFAB(
      {Key? key,
      required this.day,
      required this.inEditMode,
      required this.selectedItemsCount,
      required this.onEnterEditMode,
      required this.onInEditModePressed})
      : super(key: key);

  @override
  _ScheduleFABState createState() => _ScheduleFABState();
}

class _ScheduleFABState extends ConsumerState<ScheduleFAB> {
  final ValueNotifier<bool> _isDialOpen = ValueNotifier(false);
  String _formText = "";

  void _onFormSubmit(BuildContext context) {
    if (_formText.isNotEmpty) {
      ref
          .read(scheduleController.notifier)
          .addLessonsToDay(widget.day, _formText.trim().split("\n"));
    }
    Navigator.pop(context);
  }

  IconData? _getEditModeIcon() {
    if (widget.inEditMode) {
      if (widget.selectedItemsCount > 0) {
        return Icons.delete;
      }

      return Icons.done;
    }

    return null;
  }

  List<SpeedDialChild> _getAdditionalButtons() {
    if (widget.inEditMode) {
      return [];
    }

    final theme = Theme.of(context);

    final buttons = [
      SpeedDialChild(
          child: const Icon(Icons.add),
          labelStyle: TextStyle(color: theme.colorScheme.onPrimaryContainer),
          labelBackgroundColor: theme.colorScheme.primaryContainer,
          backgroundColor: theme.colorScheme.secondary,
          label: 'Добавить предмет',
          onTap: () {
            showMaterialModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: theme.backgroundColor,
                builder: (ctx) => ModalForm(
                      input: ModalAutoCompleteInput(
                        value: "",
                        onTextUpdate: (s) {
                          setState(() {
                            _formText = s;
                          });
                        },
                        onSubmit: (_) {
                          _onFormSubmit(ctx);
                        },
                        multiline: true,
                      ),
                      onCancel: () {
                        Navigator.pop(ctx);
                      },
                      submitButtonText: "Добавить",
                      onSubmit: () {
                        _onFormSubmit(ctx);
                      },
                    ));
          }),
      SpeedDialChild(
          child: const Icon(Icons.share_rounded),
          labelStyle: TextStyle(color: theme.colorScheme.onPrimaryContainer),
          labelBackgroundColor: theme.colorScheme.primaryContainer,
          backgroundColor: theme.colorScheme.primaryContainer,
          label: 'Поделиться',
          // TODO:
          onTap: () {
            print('Share Tapped');
          }),
    ];

    if (ref.watch(scheduleController).state.days[widget.day].lessons.isNotEmpty) {
      buttons.insert(
          1,
          SpeedDialChild(
              child: const Icon(Icons.edit),
              labelStyle: TextStyle(color: theme.colorScheme.onPrimaryContainer),
              labelBackgroundColor: theme.colorScheme.primaryContainer,
              backgroundColor: AppColors.green,
              label: 'Редактировать',
              onTap: widget.onEnterEditMode));
    }

    return buttons;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return SpeedDial(
      animatedIcon: !widget.inEditMode ? AnimatedIcons.menu_close : null,
      icon: _getEditModeIcon(),
      backgroundColor: widget.inEditMode && widget.selectedItemsCount > 0 ? AppColors.red : null,
      onPress: widget.inEditMode ? widget.onInEditModePressed : null,
      openCloseDial: _isDialOpen,
      overlayOpacity: 0,
      spacing: 15,
      spaceBetweenChildren: 15,
      children: _getAdditionalButtons(),
    );
  }
}
