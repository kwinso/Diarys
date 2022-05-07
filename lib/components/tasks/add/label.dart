import 'package:flutter/material.dart';

class AddTaskLabel extends StatelessWidget {
  final String label;
  const AddTaskLabel(this.label, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        label,
        style: TextStyle(color: Theme.of(context).colorScheme.tertiaryContainer, fontSize: 20),
      ),
    );
  }
}
