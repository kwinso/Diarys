import 'package:diarys/components/controllers_init.dart';
import 'package:diarys/components/route_bar.dart';
import 'package:diarys/state/hive/controllers/schedule.dart';
import 'package:diarys/state/hive/controllers/subjects.dart';
import 'package:diarys/state/hive/controllers/tasks.dart';
import 'package:diarys/theme/colors.dart';
import 'package:diarys/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HiveControllersInit(
      controllers: [scheduleController, tasksController, subjectsController],
      build: () => ScaffoldMessenger(
        child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: const RouteBar(name: "Настройки"),
            body: SettingsList(
              darkTheme:
                  SettingsThemeData(settingsListBackground: Theme.of(context).backgroundColor),
              lightTheme: SettingsThemeData(titleTextColor: Theme.of(context).colorScheme.tertiary),
              sections: [
                SettingsSection(
                  // title: const Text('Common'),
                  tiles: <SettingsTile>[
                    SettingsTile.switchTile(
                      onToggle: (value) => currentTheme.toggle(value: value),
                      activeSwitchColor: Theme.of(context).colorScheme.secondary,
                      initialValue: currentTheme.mode == ThemeMode.dark,
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
                          print("press");
                          ref.read(tasksController).emptyBox();
                          ref.read(scheduleController).emptyBox();
                          ref.read(subjectsController).emptyBox();
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(
                              backgroundColor: Theme.of(context).primaryColor,
                              content: Text(
                                "Хранилище очищено",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                              // content: Text("Хранилище очищено"),
                            ),
                          );
                        },
                      )
                    ])
              ],
            )
            // body: Column(
            //   children: [
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Text("Темная тема"),
            //         Switch(
            //           value: currentTheme.mode == ThemeMode.dark,
            //           onChanged: (v) {
            //             currentTheme.toggle(value: v);
            //           },
            //         ),
            //       ],
            //     ),
            //     TextButton(
            //       onPressed: () {
            //       },
            //       child: Container(
            //         color: AppColors.red,
            //         child: Text("Очистить БД"),
            //       ),
            //     )
            //   ],
            // ),
            ),
      ),
    );
  }
}
