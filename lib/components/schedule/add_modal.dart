import 'package:diarys/components/schedule/add_modal_autocomplete.dart';
import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class AddModal extends StatefulWidget {
  final VoidCallback onCancel;
  final Function(List<String>) onAdd;

  const AddModal({Key? key, required this.onCancel, required this.onAdd}) : super(key: key);

  @override
  State<AddModal> createState() => _AddModalState();
}

// TODO: Do something with setText (set both state and value for field)
class _AddModalState extends State<AddModal> {
  String _text = "";

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
                  child: AddModalAutocomplete(
                    onTextUpdate: (t) {
                      setState(() {
                        _text = t;
                      });
                    },
                  ),
                ),
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
                          if (_text.isNotEmpty) widget.onAdd(_text.trim().split("\n"));
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
