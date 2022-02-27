import 'package:diarys/components/schedule/controls.dart';
import 'package:diarys/components/schedule/lesson.dart';
import 'package:diarys/components/schedule/fab.dart';
import 'package:diarys/state/db_service.dart';
import 'package:diarys/state/schedule.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:diarys/state/types/schedule.dart';

const _listViewPadding = EdgeInsets.symmetric(horizontal: 15);

// This wrapper is need to firstly init schedule box in db, so then it can be used in _ScheduleScreenContent
class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ref.read(databaseService).openScheduleBox(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const _ScheduleScreenContent();
        }
        return Container();
      },
    );
  }

  @override
  void deactivate() {
    ref.read(databaseService).closeScheduleBox();
    super.deactivate();
  }
}

class _ScheduleScreenContent extends ConsumerStatefulWidget {
  const _ScheduleScreenContent({Key? key}) : super(key: key);

  @override
  _ScheduleScreenContentState createState() => _ScheduleScreenContentState();
}

class _ScheduleScreenContentState extends ConsumerState<_ScheduleScreenContent> {
  final SwiperController _swiperController = SwiperController();
  bool _inEditMode = false;
  List<int> _selectedItems = [];
  bool boxReady = false;
  int _currentDay = 0;

  // Fires when user taps a FAB in edit mode
  void _onEditButtonPress() {
    if (_selectedItems.isNotEmpty) {
      ref.read(scheduleController).removeLessonsInDay(_currentDay, _selectedItems);
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
  List<Widget> _lessonsListToWidgets(int dayIndex, List<String> lessons) {
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
            day: dayIndex,
            isSelected: _selectedItems.contains(e.key),
            key: Key(e.key.toString()),
            onToggleSelection: _onEditModeSelection,
            inEditMode: _inEditMode,
            index: e.key,
            name: e.value))
        .toList();
  }

  Widget Function(BuildContext, int) _getSwiperDaysBuilder(Schedule schedule) {
    return (BuildContext ctx, int dayIndex) {
      var day = schedule.days[dayIndex];
      return ListView(
          padding: _listViewPadding, children: _lessonsListToWidgets(dayIndex, day.lessons));
    };
  }

  @override
  Widget build(BuildContext context) {
    final schedule = ref.watch(scheduleController).state;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).backgroundColor,
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
                              setState(() {
                                _selectedItems = _selectedItems.map((e) {
                                  if (e == oldIdx) return moveTo;
                                  // If the non-selected item that is below selected item moved to position
                                  // Upper than selected item or on the 1st position, then we should update index
                                  // For selelected items by +1 since they're "pushed" to the bottom
                                  if (oldIdx > e && moveTo <= e) return e + 1;
                                  // Same logig with user moved non-selected item from top to bottom and
                                  // Selected item was "pushed" to the top
                                  if (oldIdx < e && moveTo >= e) return e - 1;
                                  return e;
                                }).toList();
                              });
                              ref
                                  .read(scheduleController.notifier)
                                  .moveLessonInDay(_currentDay, oldIdx, moveTo);
                            },
                            children: _lessonsListToWidgets(
                                _currentDay, schedule.days[_currentDay].lessons),
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
