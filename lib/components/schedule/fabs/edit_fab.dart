import 'package:diarys/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class EditFAB extends StatefulWidget {
  final bool itemsSelected;
  final VoidCallback onPress;
  final VoidCallback onClearSelectedItems;

  const EditFAB(
      {Key? key,
      required this.itemsSelected,
      required this.onPress,
      required this.onClearSelectedItems})
      : super(key: key);

  @override
  State<EditFAB> createState() => _EditFABState();
}

class _EditFABState extends State<EditFAB> {
  final ValueNotifier<bool> _isOpen = ValueNotifier(false);

  void _updateOpenStateAfterBuild() {
    // This will run the code right after widget runs build method, so _isOpen will be 100% called
    Future.delayed(Duration.zero, () => _isOpen.value = widget.itemsSelected);
  }

  @override
  void initState() {
    super.initState();
    _updateOpenStateAfterBuild();
  }

  @override
  void didUpdateWidget(covariant EditFAB oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateOpenStateAfterBuild();
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
        icon: widget.itemsSelected ? Icons.delete : Icons.done,
        backgroundColor: widget.itemsSelected ? AppColors.red : null,
        onClose: () {
          if (widget.itemsSelected) widget.onPress();
        },
        onPress: widget.onPress,
        openCloseDial: _isOpen,
        closeManually: true,
        renderOverlay: false,
        spacing: 15,
        spaceBetweenChildren: 15,
        children: [
          SpeedDialChild(
            child: const Icon(
              Icons.clear,
              color: Colors.white,
            ),
            labelBackgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            backgroundColor: AppColors.red,
            onTap: widget.onClearSelectedItems,
          )
        ]);
  }
}
