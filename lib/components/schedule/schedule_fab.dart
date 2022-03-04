import 'package:diarys/components/schedule/modal_form.dart';
import 'package:diarys/components/schedule/modal_input.dart';
import 'package:diarys/state/schedule.dart';
import 'package:diarys/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ScheduleFAB extends StatefulWidget {
  final bool inEditMode;
  final int day;
  final int selectedItemsCount;
  final VoidCallback onEnterEditMode;
  final VoidCallback onClearSelectedItems;
  final VoidCallback onEditCallback;

  ScheduleFAB(
      {Key? key,
      required this.inEditMode,
      required this.day,
      required this.selectedItemsCount,
      required this.onEnterEditMode,
      required this.onClearSelectedItems,
      required this.onEditCallback})
      : super(key: key);

  @override
  State<ScheduleFAB> createState() => _ScheduleFABState();
}

class _ScheduleFABState extends State<ScheduleFAB> {
  final ValueNotifier<bool> _isOpen = ValueNotifier(false);

  @override
  void didUpdateWidget(covariant ScheduleFAB oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    Future.delayed(Duration.zero, () => _isOpen.value = widget.selectedItemsCount > 0);
  }

  @override
  Widget build(BuildContext context) {
    return widget.inEditMode
        ? _EditFAB(
            isOpen: _isOpen,
            selectedItemsCount: widget.selectedItemsCount,
            onPress: widget.onEditCallback,
            onClearSelectedItems: widget.onClearSelectedItems)
        : _DefaultFAB(isOpen: _isOpen, day: widget.day, onEnterEditMode: widget.onEnterEditMode);
  }
}

class _DefaultFAB extends ConsumerStatefulWidget {
  final int day;
  final VoidCallback onEnterEditMode;
  final ValueNotifier<bool> isOpen;

  const _DefaultFAB({
    Key? key,
    required this.isOpen,
    required this.day,
    required this.onEnterEditMode,
  }) : super(key: key);

  @override
  _DefaultFABState createState() => _DefaultFABState();
}

class _DefaultFABState extends ConsumerState<_DefaultFAB> {
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
    return Container(
      child: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        openCloseDial: widget.isOpen,
        closeManually: true,
        overlayOpacity: 0.4,
        spacing: 15,
        spaceBetweenChildren: 15,
        children: _getAdditionalButtons(),
      ),
    );
  }
}

class _EditFAB extends StatefulWidget {
  final int selectedItemsCount;
  final ValueNotifier<bool> isOpen;
  final VoidCallback onPress;
  final VoidCallback onClearSelectedItems;

  _EditFAB(
      {Key? key,
      required this.selectedItemsCount,
      required this.isOpen,
      required this.onPress,
      required this.onClearSelectedItems})
      : super(key: key);

  @override
  State<_EditFAB> createState() => _EditFABState();
}

class _EditFABState extends State<_EditFAB> {
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
        icon: widget.selectedItemsCount > 0 ? Icons.delete : Icons.done,
        backgroundColor: widget.selectedItemsCount > 0 ? AppColors.red : null,
        onPress: widget.onPress,
        openCloseDial: widget.isOpen,
        closeManually: true,
        renderOverlay: false,
        spacing: 15,
        spaceBetweenChildren: 15,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.clear),
            labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
            labelBackgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            backgroundColor: AppColors.red,
            // label: "Очистить выбранное",
            onTap: widget.onClearSelectedItems,
          )
        ]);
  }
}
