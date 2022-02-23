import 'package:diarys/theme/colors.dart';
import 'package:flutter/material.dart';

class ScheduleEditModeFAB extends StatefulWidget {
  final VoidCallback onPressed;
  final int selectedItemsCount;
  ScheduleEditModeFAB({Key? key, required this.onPressed, required this.selectedItemsCount})
      : super(key: key);

  @override
  State<ScheduleEditModeFAB> createState() => _ScheduleEditModeFABState();
}

class _ScheduleEditModeFABState extends State<ScheduleEditModeFAB> {
  IconData _getCurrentIcon() {
    return widget.selectedItemsCount > 0 ? Icons.delete : Icons.done;
  }

  Color _getColor() {
    return widget.selectedItemsCount > 0 ? AppColors.red : AppColors.green;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: widget.onPressed,
      backgroundColor: _getColor(),
      child: Icon(_getCurrentIcon()),
    );
  }
}
