import 'package:diarys/components/schedule/modal_form.dart';
import 'package:diarys/components/schedule/modal_input.dart';
import 'package:diarys/state/hive/controllers/schedule.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ScheduleFAB extends ConsumerStatefulWidget {
  final ValueNotifier<int> day;

  const ScheduleFAB({
    Key? key,
    required this.day,
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
          .addLessonsToDay(widget.day.value, _newSubjectText.trim().split("\n"));
    }
    Navigator.pop(context);
  }

  List<SpeedDialChild> _getAdditionalButtons() {
    final theme = Theme.of(context);

    final buttons = [
      SpeedDialChild(
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: theme.colorScheme.secondary,
          label: 'Добавить предмет',
          onTap: () {
            AppUtils.showBottomSheet(
              context: context,
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
                  }),
            );
          }),
      SpeedDialChild(
          child: Icon(Icons.share_rounded),
          // labelBackgroundColor: theme.colorScheme.primaryContainer,
          // backgroundColor: theme.colorScheme.primaryContainer,
          label: 'Поделиться',
          // TODO:
          onTap: () {
            print('Share Tapped');
          }),
    ];

    return buttons;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      openCloseDial: _isOpen,
      renderOverlay: true,
      overlayOpacity: 0,
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
