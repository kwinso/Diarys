import 'package:diarys/components/elevated_button.dart';
import 'package:diarys/components/route_bar.dart';
import 'package:diarys/components/settings/heading.dart';
import 'package:diarys/components/settings/tiles.dart';
import 'package:diarys/state/smart_screens.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SmartScreensSettings extends ConsumerWidget {
  const SmartScreensSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(smartScreensController);
    return Scaffold(
      appBar: const RouteBar(name: "Умные экраны"),
      backgroundColor: Theme.of(context).primaryColor,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          SwitchTile(
            title: settings.enabled ? "Активно" : "Неактивно",
            value: settings.enabled,
            onChanged: (v) => settings.enabled = v,
          ),
          IgnorePointer(
            ignoring: !settings.enabled,
            child: AnimatedCrossFade(
              // opacity: settings.enabled ? 1 : 0,
              crossFadeState:
                  settings.enabled ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
              firstChild: Container(),
              secondChild: Column(
                children: [
                  ScreenTimeDropdownTile(
                    "Экран в школе",
                    value: settings.schoolScreen,
                    onChanged: (v) {
                      if (v != null) settings.schoolScreen = v;
                    },
                  ),
                  ScreenTimeDropdownTile(
                    "Экран дома",
                    value: settings.homeScreen,
                    onChanged: (v) {
                      if (v != null) settings.homeScreen = v;
                    },
                  ),
                  SwitchTile(
                    title: "Экран добавления в школе",
                    value: settings.addInSchool,
                    onChanged: (v) {
                      settings.addInSchool = v;
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: SettingsHeading("Время занятий"),
                  ),
                  SettingsTimePicker(
                    "Я в школе с",
                    value: settings.schoolStart,
                    onChanged: (v) {
                      settings.schoolStart = v;
                    },
                  ),
                  SettingsTimePicker(
                    "Я дома после",
                    value: settings.schoolEnd,
                    onChanged: (v) {
                      settings.schoolEnd = v;
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SmartScreensDescription(),
          ),
        ],
      ),
    );
  }
}

class SmartScreensDescription extends StatelessWidget {
  const SmartScreensDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Как это работает?\n",
          style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.tertiaryContainer),
        ),
        Text(
          "Умные экраны позволяют выбрать, какой экран будет показан при входе в приложение, в зависимости от времени.\n\n"
          "Если тебе хочется, чтобы в школе ты первым делом видел расписание, а дома задания, то это можно настроить здесь/\n\n"
          "Также ты можешь упростить себе жизнь, сделав так, чтобы экран добавления сразу появлялся на экране в школе.\n"
          "Это удобно: чтобы добавить задание после урока, тебе достаточно зайти в приложение и записать задание - никаких лишних движений.",
          style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.tertiaryContainer),
        ),
      ],
    );
  }
}

class SettingsTimePicker extends StatelessWidget {
  final String title;
  final TimeOfDay value;
  final Function(TimeOfDay) onChanged;
  const SettingsTimePicker(
    this.title, {
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingTile(
      title,
      interactable: AppElevatedButton(
        color: Theme.of(context).backgroundColor,
        text: "${value.hour}:${value.minute.toString().padLeft(2, "0")}",
        onPressed: () {
          showTimePicker(
            builder: (context, child) {
              return TimePickerTheme(
                data: TimePickerThemeData(
                  hourMinuteTextColor: Theme.of(context).colorScheme.tertiary,
                  hourMinuteShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: TextButtonTheme(
                  data: TextButtonThemeData(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all(Theme.of(context).colorScheme.tertiary),
                    ),
                  ),
                  child: child!,
                ),
              );
            },
            context: context,
            initialTime: value,
          ).then((value) {
            if (value != null) onChanged(value);
          });
        },
      ),
    );
  }
}

class ScreenTimeDropdownTile extends StatelessWidget {
  final String title;
  final dynamic Function(int?) onChanged;
  final int value;
  const ScreenTimeDropdownTile(
    this.title, {
    Key? key,
    required this.onChanged,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingTile(
      title,
      interactable: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<int>(
            style: TextStyle(color: Theme.of(context).colorScheme.tertiaryContainer),
            icon: const Icon(Icons.expand_more_rounded),
            value: value,
            dropdownDecoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            dropdownPadding: EdgeInsets.zero,
            offset: Offset(0, 5),
            dropdownWidth: 115,
            items: [
              DropdownMenuItem(value: 0, child: Text("Расписание")),
              DropdownMenuItem(value: 1, child: Text("Задания"))
            ],
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
