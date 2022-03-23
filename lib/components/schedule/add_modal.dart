import 'package:diarys/components/elevated_button.dart';
import 'package:diarys/components/schedule/modal_input.dart';
import 'package:diarys/theme/colors.dart';
import 'package:flutter/material.dart';

class AddModal extends StatefulWidget {
  final VoidCallback onCancel;
  final Function(List<String>) onAdd;

  const AddModal({Key? key, required this.onCancel, required this.onAdd})
      : super(key: key);

  @override
  State<AddModal> createState() => _AddModalState();
}

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
                  child: ModalAutoCompleteInput(
                    multiline: true,
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
                    AppElevatedButton(
                      onPressed: widget.onCancel,
                      text: "Отмена",
                    ),
                    AppElevatedButton(
                      color: AppColors.green,
                      onPressed: () {
                        if (_text.isNotEmpty)
                          widget.onAdd(_text.trim().split("\n"));
                      },
                      text: "Добавить",
                    )
                  ],
                )
              ],
            )));
  }
}
