import 'package:diarys/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class EditFAB extends StatefulWidget {
  final int selectedItemsCount;
  final VoidCallback onPress;
  final VoidCallback onClearSelectedItems;

  const EditFAB(
      {Key? key,
      required this.selectedItemsCount,
      required this.onPress,
      required this.onClearSelectedItems})
      : super(key: key);

  @override
  State<EditFAB> createState() => _EditFABState();
}

class _EditFABState extends State<EditFAB> {
  final ValueNotifier<bool> _isOpen = ValueNotifier(false);

  @override
  void didUpdateWidget(covariant EditFAB oldWidget) {
    super.didUpdateWidget(oldWidget);
    Future.delayed(Duration.zero, () => _isOpen.value = widget.selectedItemsCount > 0);
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
        icon: widget.selectedItemsCount > 0 ? Icons.delete : Icons.done,
        backgroundColor: widget.selectedItemsCount > 0 ? AppColors.red : null,
        onPress: widget.onPress,
        openCloseDial: _isOpen,
        closeManually: true,
        renderOverlay: false,
        spacing: 15,
        spaceBetweenChildren: 15,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.clear),
            labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
            labelBackgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            backgroundColor: AppColors.red,
            // label: "Очистить выбранное",
            onTap: widget.onClearSelectedItems,
          )
        ]);
  }
}
