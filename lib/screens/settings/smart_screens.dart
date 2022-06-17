import 'package:diarys/components/elevated_button.dart';
import 'package:diarys/components/route_bar.dart';
import 'package:diarys/components/settings/heading.dart';
import 'package:diarys/components/settings/tiles.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SmartsScreensSettings extends StatefulWidget {
  const SmartsScreensSettings({Key? key}) : super(key: key);

  @override
  State<SmartsScreensSettings> createState() => _SmartsScreensSettingsState();
}

// TODO: Create controller with all settings
class _SmartsScreensSettingsState extends State<SmartsScreensSettings> {
  bool _enabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RouteBar(name: "Умные экраны"),
      backgroundColor: Theme.of(context).primaryColor,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          SwitchTile(
            title: "Включено",
            value: _enabled,
            onChanged: (v) {
              setState(() => _enabled = v);
            },
          ),
          IgnorePointer(
            ignoring: !_enabled,
            child: AnimatedOpacity(
              opacity: _enabled ? 1 : 0,
              duration: Duration(milliseconds: 150),
              child: Column(
                children: [
                  ScreenTimeDropdownTile("Экран в школе", value: 0, onChanged: (v) => print(v)),
                  ScreenTimeDropdownTile("Экран дома", value: 1, onChanged: (v) => print(v)),
                  SwitchTile(title: "Экран добавления в школе", value: false, onChanged: (v) {}),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SettingsHeading("Время занятий"),
                  ),
                  SettingTile(
                    "Я в школе с",
                    interactable: AppElevatedButton(
                      color: Theme.of(context).backgroundColor,
                      text: "8:00",
                      onPressed: () {
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(hour: 8, minute: 0),
                        );
                      },
                    ),
                  ),
                  SettingTile(
                    "Я дома после",
                    interactable: AppElevatedButton(
                      color: Theme.of(context).backgroundColor,
                      text: "14:00",
                      onPressed: () {
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(hour: 14, minute: 0),
                        );
                      },
                    ),
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
