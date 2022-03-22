import 'package:diarys/components/controllers_init.dart';
import 'package:diarys/components/schedule/fabs/dynamic_fab.dart';
import 'package:diarys/components/schedule/swiper.dart';
import 'package:diarys/state/hive/controllers/schedule.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  final ValueNotifier<int> _currentDay = ValueNotifier(DateTime.now().weekday - 1);

  @override
  Widget build(BuildContext context) {
    return HiveControllersInit(
      controllers: [scheduleController],
      build: () => Scaffold(
        // resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).backgroundColor,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ScheduleSwiper(
              currentDay: _currentDay,
            )),
        floatingActionButton: DynamicFAB(currentDay: _currentDay),
      ),
    );
  }
}
