import 'package:diarys/components/controllers_init.dart';
import 'package:diarys/components/route_bar.dart';
import 'package:diarys/components/settings/theme.dart';
import 'package:diarys/state/hive/controllers/schedule.dart';
import 'package:diarys/state/hive/controllers/subjects.dart';
import 'package:diarys/state/hive/controllers/tasks.dart';
import 'package:diarys/theme/colors.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScaffoldMessenger(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: const RouteBar(name: "Настройки"),
        body: HiveControllersInit(
          controllers: [scheduleController, tasksController],
          build: () => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Builder(builder: (context) {
              return ListView(
                children: [
                  const SettingsHeading("Тема"),
                  const ThemeSelectSection(),
                  const SettingsHeading("Опасное место", color: AppColors.red),
                  ListTile(
                    trailing: const Icon(Icons.delete_rounded),
                    title: const Text("Очистить хранилище"),
                    onTap: () {
                      ref.read(tasksController).emptyBox();
                      ref.read(scheduleController).emptyBox();
                      ref.read(subjectsController).emptyBox();
                      AppUtils.showSnackBar(context,
                          text: "Хранилище очищено",
                          backgroundColor: Theme.of(context).backgroundColor);
                    },
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

class SettingsHeading extends StatelessWidget {
  final Color? color;
  final String text;
  const SettingsHeading(this.text, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 25, color: color),
    );
  }
}
