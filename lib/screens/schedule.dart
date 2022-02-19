import 'package:diarys/components/schedule/controls.dart';
import 'package:diarys/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class ScheduleScreen extends StatefulWidget {
  ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

// TODO: Programatically scroll when index is changed from SwiperControls
class _ScheduleScreenState extends State<ScheduleScreen> {
  final SwiperController _swiperController = SwiperController();
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
                // onIndexChanged: ,
                itemBuilder: (BuildContext ctx, int idx) {
                  return Text(AppTexts.week.days[idx]);
                },
                itemCount: 7,
                loop: true,
              ))
            ],
          )),
      floatingActionButton: FloatingActionButton(
          tooltip: "Добавить предмет",
          onPressed: () => {},
          child: const Icon(
            Icons.add,
            size: 35,
          )),
    );
  }
}
