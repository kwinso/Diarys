import 'package:diarys/components/schedule/controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class ScheduleScreen extends StatefulWidget {
  ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

// TODO: Programatically scroll when index is changed from SwiperControls
class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              ScheduleSwiperControls(
                onStep: (s) => print(s),
              ),
              Expanded(
                  child: Swiper(
                // onIndexChanged: ,
                itemBuilder: (BuildContext ctx, int idx) {
                  return Text(idx.toString());
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
