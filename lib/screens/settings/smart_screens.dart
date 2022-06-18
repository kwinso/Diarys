import 'package:diarys/components/elevated_button.dart';
import 'package:diarys/components/route_bar.dart';
import 'package:diarys/components/settings/heading.dart';
import 'package:diarys/components/settings/tiles.dart';
import 'package:diarys/state/smart_screens.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class SmartsScreensSettings extends ConsumerStatefulWidget {

//   @override
//   ConsumerState<SmartsScreensSettings> createState() => _SmartsScreensSettingsState();
// }

// TODO: Create controller with all settings
// TODO: Make own time picker (only input)
class SmartScreensSettings extends ConsumerWidget {
  const SmartScreensSettings({Key? key}) : super(key: key);
  // SharedPreferences? _prefs;
  // bool _enabled = false;
  // bool _addInSchool = false;
  // int _schoolScreen = 0;
  // int _homeScreen = 1;

  // Future<void> _getSharedPrefs() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _enabled = prefs.getBool("smart_screens:enabled") ?? false;
  //     _schoolScreen = prefs.getInt("smart_screens:school_screen") ?? 0;
  //     _homeScreen = prefs.getInt("smart_screens:home_screen") ?? 1;
  //     _addInSchool = prefs.getBool("smart_screens:add_in") ?? 1;
  //     _prefs = prefs;
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _getSharedPrefs();
  // }

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
            child: AnimatedOpacity(
              opacity: settings.enabled ? 1 : 0,
              duration: const Duration(milliseconds: 150),
              child: Column(
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
                    value: settings.inSchoolTime,
                    onChanged: (v) {
                      settings.inSchoolTime = v;
                    },
                  ),
                  SettingsTimePicker(
                    "Я дома после",
                    value: settings.atHomeTime,
                    onChanged: (v) {
                      settings.atHomeTime = v;
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
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
