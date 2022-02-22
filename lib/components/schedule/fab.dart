import 'package:diarys/state/schedule.dart';
import 'package:diarys/state/subjects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'add_modal.dart';

class ScheduleFAB extends ConsumerStatefulWidget {
  final int day;

  const ScheduleFAB({Key? key, required this.day}) : super(key: key);

  @override
  _ScheduleFABState createState() => _ScheduleFABState();
}

class _ScheduleFABState extends ConsumerState<ScheduleFAB> {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  @override
  Widget build(
    BuildContext context,
  ) {
    var schedule = ref.read(scheduleController.notifier);
    var subjects = ref.read(subjectsController.notifier);

    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      openCloseDial: isDialOpen,
      overlayOpacity: 0,
      spacing: 15,
      spaceBetweenChildren: 15,
      children: [
        SpeedDialChild(
            child: const Icon(Icons.add),
            labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
            labelBackgroundColor: Theme.of(context).colorScheme.primaryContainer,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            label: 'Добавить предмет',
            onTap: () {
              showMaterialModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: Theme.of(context).backgroundColor,
                builder: (context) => AddModal(
                  onCancel: () {
                    Navigator.pop(context);
                  },
                  onAdd: (lessons) {
                    schedule.addLessonsToDay(widget.day, lessons);
                    subjects.addUniqueSubjects(lessons);
                    Navigator.pop(context);
                  },
                ),
              );
            }),
        SpeedDialChild(
            child: const Icon(Icons.share_rounded),
            labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
            labelBackgroundColor: Theme.of(context).colorScheme.primaryContainer,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            label: 'Поделиться',
            // TODO:
            onTap: () {
              print('Share Tapped');
            }),
      ],
    );
  }
}
