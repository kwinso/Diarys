import 'package:diarys/components/schedule/fabs/edit_fab.dart';
import 'package:diarys/components/schedule/fabs/schedule_fab.dart';
import 'package:diarys/state/edit_schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DynamicFAB extends ConsumerWidget {
  final ValueNotifier<int> currentDay;
  const DynamicFAB({Key? key, required this.currentDay}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final editMode = ref.watch(editModeController);

    return editMode.active
        ? EditFAB(
            itemsSelected: editMode.selectedItems.isNotEmpty,
            onPress: () {
              if (editMode.selectedItems.isNotEmpty) {
                editMode.deleteSelected();
              } else {
                editMode.active = false;
              }
            },
            onClearSelectedItems: () => editMode.clearSelected(),
          )
        : ScheduleFAB(
            day: currentDay,
          );
  }
}
