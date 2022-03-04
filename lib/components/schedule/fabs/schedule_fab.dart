import 'package:diarys/components/schedule/modal_form.dart';
import 'package:diarys/components/schedule/modal_input.dart';
import 'package:diarys/state/schedule.dart';
import 'package:diarys/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

//TODO: Some day implement own overlay instead of speed dial one.
class ScheduleFAB extends ConsumerStatefulWidget {
  final int day;
  final VoidCallback onEnterEditMode;

  const ScheduleFAB({
    Key? key,
    required this.day,
    required this.onEnterEditMode,
  }) : super(key: key);

  @override
  _ScheduleFABState createState() => _ScheduleFABState();
}

class _ScheduleFABState extends ConsumerState<ScheduleFAB> {
  final ValueNotifier<bool> _isOpen = ValueNotifier(false);
  String _newSubjectText = "";

  void _onFormSubmit(BuildContext context) {
    if (_newSubjectText.isNotEmpty) {
      ref
          .read(scheduleController.notifier)
          .addLessonsToDay(widget.day, _newSubjectText.trim().split("\n"));
    }
    Navigator.pop(context);
  }

  List<SpeedDialChild> _getAdditionalButtons() {
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
                            _newSubjectText = s;
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
      animatedIcon: AnimatedIcons.menu_close,
      openCloseDial: _isOpen,
      renderOverlay: false,
      spacing: 15,
      spaceBetweenChildren: 15,
      children: _getAdditionalButtons(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
