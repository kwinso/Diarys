import 'package:diarys/state/schedule.dart';
import 'package:diarys/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ScheduleFAB extends ConsumerWidget {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  final int day;

  ScheduleFAB({Key? key, required this.day}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final schedule = ref.read(scheduleController.notifier);

    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      openCloseDial: isDialOpen,
      overlayOpacity: 0,
      spacing: 15,
      spaceBetweenChildren: 15,
      children: [
        SpeedDialChild(
            child: const Icon(Icons.add),
            labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
            labelBackgroundColor: Theme.of(context).colorScheme.primaryContainer,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            label: 'Добавить предмет',
            onTap: () {
              showMaterialModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: Theme.of(context).backgroundColor,
                builder: (context) => AddModal(
                  onCancel: () {
                    Navigator.pop(context);
                  },
                  onAdd: (lessons) {
                    schedule.add(day, lessons);
                    Navigator.pop(context);
                  },
                ),
              );
            }),
        SpeedDialChild(
            child: const Icon(Icons.share_rounded),
            labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
            labelBackgroundColor: Theme.of(context).colorScheme.primaryContainer,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            label: 'Поделиться',
            // TODO:
            onTap: () {
              print('Share Tapped');
            }),
      ],
    );
  }
}

class AddModal extends StatefulWidget {
  final VoidCallback onCancel;
  final Function(List<String>) onAdd;

  const AddModal({Key? key, required this.onCancel, required this.onAdd}) : super(key: key);

  @override
  State<AddModal> createState() => _AddModalState();
}

class _AddModalState extends State<AddModal> {
  String text = "";
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
              top: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom + 15,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: TextFormField(
                        // initialValue: text,
                        controller: _controller,
                        onChanged: (t) {
                          // Max name length is 20 chars
                          if (t.trim().split("\n").last.length > 20) {
                            // Set the prev text and set cursor on the end of the text
                            // This way we forbid user  to type after 20 chars
                            _controller.value = TextEditingValue(
                              text: text,
                              selection: TextSelection(
                                  baseOffset: text.length,
                                  extentOffset: text.length,
                                  affinity: TextAffinity.downstream,
                                  isDirectional: false),
                            );
                          } else {
                            setState(() {
                              text = t;
                            });
                          }
                        },
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        autofocus: true,
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        decoration: InputDecoration(
                            hintText: "Название предмета",
                            hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.tertiaryContainer)))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: widget.onCancel,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: const BorderRadius.all(Radius.circular(12))),
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: Text(
                            "Отмена",
                            style: TextStyle(
                                fontSize: 15, color: Theme.of(context).colorScheme.tertiary),
                          ),
                        )),
                    TextButton(
                        onPressed: () {
                          if (text.isNotEmpty) widget.onAdd(text.trim().split("\n"));
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              color: AppColors.green,
                              borderRadius: BorderRadius.all(Radius.circular(12))),
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: Text(
                            "Добавить",
                            style: TextStyle(
                                fontSize: 15, color: Theme.of(context).colorScheme.tertiary),
                          ),
                        ))
                  ],
                )
              ],
            )));
  }
}
