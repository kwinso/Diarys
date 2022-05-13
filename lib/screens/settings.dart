import 'package:diarys/components/controllers_init.dart';
import 'package:diarys/components/route_bar.dart';
import 'package:diarys/state/hive/controllers/schedule.dart';
import 'package:diarys/state/hive/controllers/subjects.dart';
import 'package:diarys/state/hive/controllers/tasks.dart';
import 'package:diarys/theme/colors.dart';
import 'package:diarys/theme/themes.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';

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
          build: () => SettingsList(
            darkTheme: SettingsThemeData(settingsListBackground: Theme.of(context).primaryColor),
            lightTheme: SettingsThemeData(settingsListBackground: Theme.of(context).primaryColor),
            sections: [
              SettingsSection(
                tiles: <SettingsTile>[
                  SettingsTile.switchTile(
                    onToggle: (value) => ref.read(themeController).toggle(value: value),
                    activeSwitchColor: Theme.of(context).colorScheme.secondary,
                    initialValue: ref.watch(themeController).mode == ThemeMode.dark,
                    leading: const Icon(Icons.dark_mode_outlined),
                    title: const Text('Темная тема'),
                  ),
                ],
              ),
              SettingsSection(
                  title: const Text(
                    "Опасное место",
                    style: TextStyle(color: AppColors.red),
                  ),
                  tiles: [
                    SettingsTile(
                      leading: const Icon(Icons.delete),
                      title: const Text("Очистить хранилище"),
                      onPressed: (ctx) {
                        ref.read(tasksController).emptyBox();
                        ref.read(scheduleController).emptyBox();
                        ref.read(subjectsController).emptyBox();
                        AppUtils.showSnackBar(ctx, text: "Хранилище очищено");
                      },
                    )
                  ])
            ],
          ),
        ),
      ),
    );
  }
}
