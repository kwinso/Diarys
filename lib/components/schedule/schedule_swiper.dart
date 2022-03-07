import 'package:diarys/components/schedule/controls.dart';
import 'package:diarys/components/schedule/lesson.dart';
import 'package:diarys/state/edit_mode.dart';
import 'package:diarys/state/hive_types/schedule.dart';
import 'package:diarys/state/schedule.dart';
import 'package:diarys/state/types/delete_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

const _listViewPadding = EdgeInsets.symmetric(horizontal: 15);

class ScheduleSwiper extends ConsumerStatefulWidget {
  final ValueNotifier<int> currentDay;
  // final Function(int) onChangeDay;
  ScheduleSwiper({Key? key, required this.currentDay}) : super(key: key);

  @override
  _ScheduleSwiperState createState() => _ScheduleSwiperState();
}

class _ScheduleSwiperState extends ConsumerState<ScheduleSwiper> {
  final SwiperController _swiperController = SwiperController();

  // Fires when user selects a lesson in edit mode
  void _onEditModeSelection(int day, int index) {
    final editMode = ref.read(editModeController);
    final items = editMode.selectedItems;
    final alreadySelected = items.any((e) => e.day == day && e.index == index);
    // setState(() {
    if (!alreadySelected) {
      items.add(DeleteEntry(day, index));
      editMode.selectedItems = items;
    } else {
      items.removeWhere((e) => e.day == day && e.index == index);
      editMode.selectedItems = items;
    }
    // });
  }

  // Converts lessons names to a list of ScheduleLesson
  List<Widget> _lessonsListToWidgets(
      int dayIndex, List<String> lessons, EditModeController editMode) {
    if (lessons.isEmpty) {
      return [
        Text(
          "Пусто",
          key: const Key("empty"),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25, color: Theme.of(context).colorScheme.tertiaryContainer),
        )
      ];
    }
    return lessons
        .asMap()
        .entries
        .map((e) => ScheduleLesson(
            key: ValueKey(e.key),
            day: dayIndex,
            isSelected: editMode.selectedItems
                .any((entry) => entry.day == dayIndex && entry.index == e.key),
            onToggleSelection: _onEditModeSelection,
            inEditMode: editMode.active,
            index: e.key,
            name: e.value))
        .toList();
  }

  Widget Function(BuildContext, int) _getSwiperDaysBuilder() {
    final schedule = ref.watch(scheduleController).state;
    final editMode = ref.watch(editModeController);

    return (BuildContext ctx, int dayIndex) {
      var day = schedule.days[dayIndex];
      if (editMode.active) {
        return ReorderableListView(
          buildDefaultDragHandles: false,
          padding: _listViewPadding,
          proxyDecorator: (w, i, z) => Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor,
                      blurRadius: 10,
                    )
                  ]),
              child: w),
          onReorder: (oldIdx, newIdx) {
            // Since onReorder gives a index that also counts the current item in list
            // we should check wether the index accurate
            final moveTo = newIdx > oldIdx ? newIdx - 1 : newIdx;
            editMode.selectedItems = editMode.selectedItems.map((e) {
              if (widget.currentDay.value == e.day) {
                if (e.index == oldIdx) {
                  e.index = moveTo;
                }
                // If the non-selected item that is below selected item moved to position
                // Upper than selected item or on the 1st position, then we should update index
                // For selelected items by +1 since they're "pushed" to the bottom
                else if (oldIdx > e.index && moveTo <= e.index) {
                  e.index += 1;
                }
                // Same logig with user moved non-selected item from top to bottom and
                // Selected item was "pushed" to the top
                else if (oldIdx < e.index && moveTo >= e.index) {
                  e.index -= 1;
                }
              }
              return e;
            }).toList();
            ref
                .read(scheduleController.notifier)
                .moveLessonInDay(widget.currentDay.value, oldIdx, moveTo);
          },
          children: _lessonsListToWidgets(dayIndex, day.lessons, editMode),
        );
      }
      return ListView(
          padding: _listViewPadding,
          children: _lessonsListToWidgets(dayIndex, day.lessons, editMode));
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ScheduleSwiperControls(
        onNext: () => _swiperController.next(),
        onPrev: () => _swiperController.previous(),
        index: widget.currentDay.value,
      ),
      Expanded(
          child: Swiper(
              curve: Curves.linear,
              controller: _swiperController,
              index: widget.currentDay.value,
              onIndexChanged: (idx) => setState(() => widget.currentDay.value = idx),
              itemBuilder: _getSwiperDaysBuilder(),
              itemCount: 7,
              loop: true))
    ]);
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }
}
