import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class TaskSubjectInput extends ConsumerStatefulWidget {
  const TaskSubjectInput({Key? key}) : super(key: key);

  @override
  _TaskSubjectInputState createState() => _TaskSubjectInputState();
}

class _TaskSubjectInputState extends ConsumerState<TaskSubjectInput> {
  String _subject = "";
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: _textController,
        onChanged: (s) => setState(() {
          _subject = s;
        }),
        autofocus: true,
        maxLines: 1,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 20),
        // style: DefaultTextStyle.of(context).style.copyWith(fontStyle: FontStyle.italic),
        decoration: InputDecoration(
          hintText: "Предмет",
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.tertiaryContainer),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      hideSuggestionsOnKeyboardHide: true,
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.primary,
      ),
      hideOnEmpty: true,
      noItemsFoundBuilder: (_) => Container(),
      suggestionsCallback: (pattern) {
        return AppUtils.getSubjectSuggestions(ref, pattern, true);
      },
      itemBuilder: (context, String suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      onSuggestionSelected: (String suggestion) {
        _textController.text = suggestion;
        _textController.selection = TextSelection.collapsed(offset: suggestion.length);
      },
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
