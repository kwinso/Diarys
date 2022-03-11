import 'package:diarys/components/schedule/fabs/dynamic_fab.dart';
import 'package:diarys/components/schedule/schedule_swiper.dart';
import 'package:diarys/components/tasks_list.dart';
import 'package:diarys/state/db_service.dart';
import 'package:diarys/state/hive_types/schedule.dart';
import 'package:diarys/state/hive_types/tasks_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  final ValueNotifier<int> _currentDay = ValueNotifier(DateTime.now().weekday - 1);

  Widget _buildContent(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).backgroundColor,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ScheduleSwiper(
              currentDay: _currentDay,
            )),
        floatingActionButton: DynamicFAB(currentDay: _currentDay));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ref.read(databaseService).openSchedule(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildContent(context);
        }
        return Container();
      },
    );
  }

  @override
  void deactivate() {
    ref.read(databaseService).scheduleBox.close();
    super.deactivate();
  }
}
