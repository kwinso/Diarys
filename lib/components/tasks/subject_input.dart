import 'package:diarys/state/add_task.dart';
import 'package:diarys/theme/colors.dart';
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
    _textController = TextEditingController(text: ref.read(addTaskController).subject);
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
              if (v.length > 20) return "Не более 20 символов";

              return null;
            },
            suggestionsBoxVerticalOffset: 5,
            textFieldConfiguration: TextFieldConfiguration(
              controller: _textController,
              onChanged: (s) => ref.read(addTaskController).subject = s.trim(),
              autofocus: true,
              maxLines: 1,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 20),
              decoration: InputDecoration(
                hintText: "Предмет",
                hintStyle: TextStyle(color: Theme.of(context).colorScheme.primaryContainer),
                filled: true,
                fillColor: Theme.of(context).backgroundColor,
                alignLabelWithHint: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            hideSuggestionsOnKeyboardHide: true,
            hideOnLoading: true,
            keepSuggestionsOnSuggestionSelected: false,
            suggestionsBoxDecoration: SuggestionsBoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).backgroundColor,
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
                ref.read(addTaskController).subject = suggestion;
                // ref.read(addTaskCortroller).setSubject(suggestion);
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
