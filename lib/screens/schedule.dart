import 'package:diarys/components/schedule/controls.dart';
import 'package:diarys/components/schedule/edit_fab.dart';
import 'package:diarys/components/schedule/lesson.dart';
import 'package:diarys/components/schedule/fab.dart';
import 'package:diarys/state/schedule.dart';
import 'package:flutter/gestures.dart';
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
  int _index = 0;

  void _onEditModeDone() {
    if (_selectedItems.isNotEmpty) {
      ref.read(scheduleController.notifier).removeLessonsInDay(0, _selectedItems);
    }
    setState(() {
      _selectedItems.clear();
      _inEditMode = false;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    final schedule = ref.watch(scheduleController);
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                ScheduleSwiperControls(
                  onNext: () => _swiperController.next(),
                  onPrev: () => _swiperController.previous(),
                  index: _index,
                ),
                Expanded(
                    child: Swiper(
                  controller: _swiperController,
                  index: _index,
                  onIndexChanged: (idx) => setState(() {
                    _index = idx;
                  }),
                  itemBuilder: (BuildContext ctx, int idx) {
                    var day = schedule.days[idx];
                    if (day.lessons.isNotEmpty) {
                      return ReorderableListView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          onReorder: (oldIndex, newIndex) {
                            if (_selectedItems.contains(oldIndex)) {
                              setState(() {
                                _selectedItems.remove(oldIndex);
                                _selectedItems.add(newIndex);
                              });
                            }
                            ref
                                .read(scheduleController.notifier)
                                .moveLessonInDay(idx, oldIndex, newIndex);
                          },
                          children: day.lessons
                              .asMap()
                              .entries
                              .map((e) => GestureDetector(
                                  // Disables longpress on item so it can't be gragged in normal mode
                                  onLongPress: !_inEditMode ? () {} : null,
                                  key: Key(e.key.toString()),
                                  child: ScheduleLesson(
                                      isSelected: _selectedItems.contains(e.key),
                                      onToggleSelection: _onEditModeSelection,
                                      inEditMode: _inEditMode,
                                      index: e.key,
                                      name: e.value)))
                              .toList());
                    }

                    return Text(
                      "Пусто",
                      key: Key(idx.toString()),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25, color: Theme.of(context).colorScheme.tertiaryContainer),
                    );
                  },
                  itemCount: 7,
                  loop: true,
                ))
              ],
            )),
        floatingActionButton: _inEditMode
            ? ScheduleEditModeFAB(
                selectedItemsCount: _selectedItems.length, onDone: _onEditModeDone)
            : ScheduleFAB(
                onEnterEditMode: () => setState(() {
                  _inEditMode = true;
                }),
                day: _index,
              ));
  }
}
