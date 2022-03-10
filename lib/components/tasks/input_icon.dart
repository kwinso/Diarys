import 'package:flutter/material.dart';

class InputIcon extends StatelessWidget {
  final IconData icon;
  const InputIcon(this.icon, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: Icon(icon, color: Theme.of(context).colorScheme.tertiary),
    );
  }
}
