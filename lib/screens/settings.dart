import 'package:diarys/components/controllers_init.dart';
import 'package:diarys/components/route_bar.dart';
import 'package:diarys/state/hive/controllers/schedule.dart';
import 'package:diarys/state/hive/controllers/subjects.dart';
import 'package:diarys/state/hive/controllers/tasks.dart';
import 'package:diarys/theme/colors.dart';
import 'package:diarys/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HiveControllersInit(
      controllers: [scheduleController, tasksController, subjectsController],
      build: () => Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: RouteBar(name: "Настройки"),
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Темная тема"),
                  Switch(
                    value: currentTheme.mode == ThemeMode.dark,
                    onChanged: (v) {
                      currentTheme.toggle(value: v);
                    },
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  ref.read(tasksController).emptyBox();
                  ref.read(scheduleController).emptyBox();
                  ref.read(subjectsController).emptyBox();
                },
                child: Container(
                  color: AppColors.red,
                  child: Text("Очистить БД"),
                ),
              )
            ],
          )),
    );
  }
}
