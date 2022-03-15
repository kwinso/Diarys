import 'package:flutter/material.dart';

class FieldIcon extends StatelessWidget {
  final IconData icon;
  const FieldIcon(this.icon, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Icon(icon, color: Theme.of(context).colorScheme.tertiary),
    );
  }
}
