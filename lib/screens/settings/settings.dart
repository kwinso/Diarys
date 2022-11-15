import 'package:diarys/components/controllers_init.dart';
import 'package:diarys/components/route_bar.dart';
import 'package:diarys/components/settings/heading.dart';
import 'package:diarys/components/settings/theme.dart';
import 'package:diarys/screens/settings/smart_screens.dart';
import 'package:diarys/state/hive/controllers/schedule.dart';
import 'package:diarys/state/hive/controllers/subjects.dart';
import 'package:diarys/state/hive/controllers/tasks.dart';
import 'package:diarys/theme/colors.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:diarys/components/SettingsLogo.dart';

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
          build: () => Builder(builder: (context) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SettingsHeading("Тема"),
                  const ThemeSelectSection(),
                  ListTile(
                    title: const Text("Умные экраны"),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => const SmartScreensSettings())),
                  ),
                  const SettingsHeading("Опасное место", color: AppColors.red),
                  ListTile(
                    title: const Text("Удалить все данные"),
                    trailing: const Icon(Icons.delete_rounded),
                    onTap: () async {
                      var confirmed = await AppUtils.showAppDialog(
                        context,
                        description:
                            "Данное действие удалит все данные, включая расписание и домашние задания.",
                        title: "Аккуратнее!",
                        confirmButtonText: "Удалить",
                        confirmButtonColor: AppColors.red,
                      );
                      if (confirmed) {
                        ref.read(tasksController).emptyBox();
                        ref.read(scheduleController).emptyBox();
                        ref.read(subjectsController).emptyBox();
                        AppUtils.showSnackBar(context,
                            text: "Данные удалены",
                            backgroundColor: Theme.of(context).backgroundColor);
                      }
                    },
                  ),
                  const Spacer(),
                  const SettingsLogo()
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
