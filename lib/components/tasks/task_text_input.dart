import 'package:diarys/state/edit_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskTextInput<T extends TaskEditController> extends ConsumerWidget {
  final ChangeNotifierProvider<T> controller;
  const TaskTextInput({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      initialValue: ref.read(controller).content,
      onChanged: (t) {
        t = t.trim();
        if (ref.read(controller).content != t) ref.read(controller).content = t;
      },
      maxLines: null,
      textCapitalization: TextCapitalization.sentences,
      style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        hintText: "Мне задали...",
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.primaryContainer),
        filled: true,
        fillColor: Theme.of(context).primaryColor,
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
