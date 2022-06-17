import 'package:flutter/material.dart';

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
