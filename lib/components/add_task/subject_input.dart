import 'package:diarys/state/add_task.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SubjectInput extends ConsumerStatefulWidget {
  const SubjectInput({
    Key? key,
  }) : super(key: key);

  @override
  _SubjectInputState createState() => _SubjectInputState();
}

class _SubjectInputState extends ConsumerState<SubjectInput> {
  var _textController = TextEditingController();

  @override
  void initState() {
    _textController = TextEditingController(text: ref.read(addTaskController).data.subject);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TypeAheadFormField(
            validator: (v) {
              if (v!.isEmpty) return "Введите имя предмета";
              if (v.length > 20) return "Максимум: 20 символов";

              return null;
            },
            textFieldConfiguration: TextFieldConfiguration(
              controller: _textController,
              onChanged: (s) => setState(() {
                ref.read(addTaskController).setSubject(s.trim());
              }),
              autofocus: true,
              maxLines: 1,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 20),
              decoration: InputDecoration(
                labelText: "Предмет",
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.tertiaryContainer),
                alignLabelWithHint: true,
                contentPadding: const EdgeInsets.only(right: 5, left: 5, bottom: 10),
              ),
            ),
            hideSuggestionsOnKeyboardHide: true,
            hideOnLoading: true,
            keepSuggestionsOnSuggestionSelected: false,
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
                title: Text(
                  suggestion,
                  style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                ),
              );
            },
            onSuggestionSelected: (String suggestion) {
              setState(() {
                ref.read(addTaskController).setSubject(suggestion);
              });
              _textController.text = suggestion;
              _textController.selection = TextSelection.collapsed(offset: suggestion.length);
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
