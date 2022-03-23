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
            TextButton(
                onPressed: widget.onCancel,
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12))),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    "Отмена",
                    style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.tertiary),
                  ),
                )),
            TextButton(
                onPressed: () => widget.onSubmit(),
                child: Container(
                  decoration: const BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    widget.submitButtonText,
                    style: const TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ))
          ],
        )
      ],
    );
  }
}
