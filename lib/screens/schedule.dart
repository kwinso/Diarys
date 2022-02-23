import 'package:diarys/components/schedule/controls.dart';
import 'package:diarys/components/schedule/edit_fab.dart';
import 'package:diarys/components/schedule/lesson.dart';
import 'package:diarys/components/schedule/fab.dart';
import 'package:diarys/state/schedule.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  final SwiperController _swiperController = SwiperController();
  bool _inEditMode = false;
  final List<int> _selectedItems = [];
  int _currentDay = 0;

  // Fires when user taps a FAB in edit mode
  void _onEditButtonPress() {
    if (_selectedItems.isNotEmpty) {
      ref.read(scheduleState.notifier).removeLessonsInDay(_currentDay, _selectedItems);
    }
    setState(() {
      _selectedItems.clear();
      _inEditMode = false;
    });
  }

  // Fires when user selects a lesson in edit mode
  void _onEditModeSelection(int index) {
    final alreadySelected = _selectedItems.contains(index);
    setState(() {
      if (!alreadySelected) {
        _selectedItems.add(index);
      } else {
        _selectedItems.remove(index);
      }
    });
  }

  // Converts lessons names to a list of ScheduleLesson
  List<Widget> _lessonsListToWidgets(List<String> lessons) {
    if (lessons.isEmpty) {
      return [
        Text(
          "Пусто",
          key: Key("empty"),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25, color: Theme.of(context).colorScheme.tertiaryContainer),
        )
      ];
    }
    return lessons
        .asMap()
        .entries
        .map((e) => ScheduleLesson(
            isSelected: _selectedItems.contains(e.key),
            key: Key(e.key.toString()),
            onToggleSelection: _onEditModeSelection,
            inEditMode: _inEditMode,
            index: e.key,
            name: e.value))
        .toList();
  }

  Widget Function(BuildContext, int) _getSwiperDaysBuilder(Schedule schedule) {
    return (BuildContext ctx, int idx) {
      var day = schedule.days[idx];
      return ListView(children: _lessonsListToWidgets(day.lessons));
    };
  }

  @override
  Widget build(BuildContext context) {
    final schedule = ref.watch(scheduleState);
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                ScheduleSwiperControls(
                  onNext: () => _swiperController.next(),
                  onPrev: () => _swiperController.previous(),
                  index: _currentDay,
                ),
                Expanded(
                    child: _inEditMode
                        ? ReorderableListView(
                            onReorder: (oldIdx, newIdx) {
                              // Since onReorder gives a index that also counts the current item in list
                              // we should check wether the index accurate
                              final moveTo = newIdx > oldIdx ? newIdx - 1 : newIdx;
                              if (_selectedItems.contains(oldIdx)) {
                                setState(() {
                                  _selectedItems.remove(oldIdx);
                                  _selectedItems.add(moveTo);
                                });
                              }
                              ref
                                  .read(scheduleState.notifier)
                                  .moveLessonInDay(_currentDay, oldIdx, moveTo);
                            },
                            children: _lessonsListToWidgets(schedule.days[_currentDay].lessons),
                          )
                        : Swiper(
                            controller: _swiperController,
                            index: _currentDay,
                            onIndexChanged: (idx) => setState(() {
                              _currentDay = idx;
                            }),
                            itemBuilder: _getSwiperDaysBuilder(schedule),
                            itemCount: 7,
                            loop: true,
                          ))
              ],
            )),
        floatingActionButton: ScheduleFAB(
          inEditMode: _inEditMode,
          selectedItemsCount: _selectedItems.length,
          onInEditModePressed: _onEditButtonPress,
          onEnterEditMode: () {
            setState(() {
              _inEditMode = true;
            });
          },
          day: _currentDay,
        ));
  }
}
