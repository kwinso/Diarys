import 'package:diarys/components/schedule/controls.dart';
import 'package:diarys/components/schedule/lesson.dart';
import 'package:diarys/schedule.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class ScheduleScreen extends StatefulWidget {
  final Schedule schedule;
  ScheduleScreen({Key? key, required this.schedule}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final SwiperController _swiperController = SwiperController();
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
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
                    return NotificationListener<OverscrollIndicatorNotification>(
                        onNotification: (overscroll) {
                          overscroll.disallowIndicator();
                          return false;
                        },
                        child: ListView(
                          //    Column(
                          // // mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: widget.schedule.days[idx].lessons
                              .asMap()
                              .entries
                              .map((e) => ScheduleLesson(
                                    name: e.value,
                                    index: e.key,
                                  ))
                              .toList(),
                          // children: [
                          //   ScheduleLesson(),
                          //   ScheduleLesson(),
                          //   ScheduleLesson(),
                          //   ScheduleLesson(),
                          //   ScheduleLesson(),
                          //   ScheduleLesson(),
                          //   ScheduleLesson(),
                          //   ScheduleLesson(),
                          //   ScheduleLesson(),
                          //   ScheduleLesson(),
                          //   ScheduleLesson(),
                          //   ScheduleLesson(),
                          // ],
                        ));
                    // return Text(AppTexts.week.days[idx]);
                  },
                  itemCount: 7,
                  loop: true,
                ))
              ],
            )),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          openCloseDial: isDialOpen,
          overlayOpacity: 0,
          spacing: 15,
          spaceBetweenChildren: 15,
          closeManually: false,
          children: [
            SpeedDialChild(
                child: const Icon(Icons.add),
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                labelBackgroundColor: Theme.of(context).colorScheme.primaryContainer,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                label: 'Добавить предмет',
                // TODO:
                onTap: () {
                  print('Add Tapped');
                }),
            SpeedDialChild(
                child: const Icon(Icons.share_rounded),
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                labelBackgroundColor: Theme.of(context).colorScheme.primaryContainer,
                // foregroundColor: Theme.of(context).colorScheme.onPrimary,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                label: 'Поделиться',
                // TODO:
                onTap: () {
                  print('Share Tapped');
                }),
          ],
        ));
    // floatingActionButton: InkWell(
    //     splashColor: Colors.blue,
    //     onLongPress: () {
    //       print("Long Press");
    //       // handle your long press functionality here
    //     },
    //     child: FloatingActionButton(

    //         // tooltip: "Добавить предмет",
    //         onPressed: () => {},
    //         child: const Icon(
    //           Icons.menu,
    //           // size: 35,
    //         ))));
  }
}
