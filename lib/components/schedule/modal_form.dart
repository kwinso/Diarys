import 'package:diarys/components/elevated_button.dart';
import 'package:diarys/components/schedule/modal_input.dart';
import 'package:diarys/components/schedule/mutliline_hint.dart';
import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class ModalForm extends StatefulWidget {
  final VoidCallback onCancel;
  final String submitButtonText;
  final ModalAutoCompleteInput input;
  final VoidCallback onSubmit;

  const ModalForm(
      {Key? key,
      required this.onCancel,
      required this.input,
      required this.submitButtonText,
      required this.onSubmit})
      : super(key: key);

  @override
  State<ModalForm> createState() => _ModalFormState();
}

class _ModalFormState extends State<ModalForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: widget.input,
        ),
        widget.input.multiline ? const MultilineHint() : Container(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: AppElevatedButton(
                text: "Отмена",
                color: AppColors.red,
                foregroundColor: Colors.white,
                onPressed: () => widget.onCancel(),
              ),
            ),
            AppElevatedButton(
              text: widget.submitButtonText,
              color: AppColors.green,
              foregroundColor: Colors.white,
              onPressed: () => widget.onSubmit(),
            ),
          ],
        )
      ],
    );
  }
}
