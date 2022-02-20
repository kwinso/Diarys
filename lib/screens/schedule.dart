import 'package:diarys/components/schedule/controls.dart';
import 'package:diarys/components/schedule/lesson.dart';
import 'package:diarys/components/schedule/fab.dart';
import 'package:diarys/state/schedule.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class ScheduleScreen extends StatefulWidget {
  ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final SwiperController _swiperController = SwiperController();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (
      context,
      watch,
      child,
    ) {
      final schedule = watch.watch(scheduleController);
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
                      return NotificationListener<OverscrollIndicatorNotification>(
                          onNotification: (overscroll) {
                            overscroll.disallowIndicator();
                            return false;
                          },
                          child: ListView(
                              children: day.lessons.isNotEmpty
                                  ? day.lessons
                                      .asMap()
                                      .entries
                                      .map((e) => ScheduleLesson(index: e.key, name: e.value))
                                      .toList()
                                  : [
                                      Text(
                                        "Пусто",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Theme.of(context).colorScheme.tertiaryContainer),
                                      )
                                    ]));
                      // return Text(AppTexts.week.days[idx]);
                    },
                    itemCount: 7,
                    loop: true,
                  ))
                ],
              )),
          floatingActionButton: ScheduleFAB(
            day: _index,
          ));
    });
  }
}
