import 'dart:async';
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
  _TaskNameInputState createState() => _TaskNameInputState();
}

class _TaskNameInputState extends ConsumerState<SubjectInput> {
  String _text = "";
  Timer? _debounce;
  final _textController = TextEditingController();
  final int _debounceTime = 500;

  @override
  void initState() {
    _textController.addListener(_onTextChange);
    super.initState();
  }

  void _onTextChange() {
    // if (_debounce?.isActive ?? false) _debounce!.cancel();
    // _debounce = Timer(Duration(milliseconds: _debounceTime), () {
    ref.read(addTaskController).setSubject(_text);
    // });
  }

  @override
  Widget build(BuildContext context) {
    // final text = ref.watch(addTaskController).data.subject;

    return Row(
      children: [
        Expanded(
          child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              controller: _textController,
              onChanged: (s) => setState(() {
                _text = s;
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
                _text = suggestion;
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
    _textController.removeListener(_onTextChange);
    _debounce!.cancel();
    _textController.dispose();
    super.dispose();
  }
}
