import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  final String title;
  final Widget interactable;
  const SettingTile(this.title, {Key? key, required this.interactable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(title, style: const TextStyle(fontSize: 16)), interactable],
    );
  }
}

class SwitchTile extends StatelessWidget {
  final bool value;
  final String title;
  final Function(bool) onChanged;
  const SwitchTile({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingTile(
      title,
      interactable: Transform.scale(
        scale: 0.8,
        child: CupertinoSwitch(
          activeColor: Theme.of(context).colorScheme.secondary,
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
