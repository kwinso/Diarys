import 'package:diarys/state/subjects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddModalAutocomplete extends ConsumerStatefulWidget {
  final Function(String text) onTextUpdate;
  AddModalAutocomplete({
    Key? key,
    required this.onTextUpdate,
  }) : super(key: key);

  @override
  _AddModalAutocompleteState createState() => _AddModalAutocompleteState();
}

class _AddModalAutocompleteState extends ConsumerState<AddModalAutocomplete> {
  String _text = "";
  List<String> _suggestions = [];
  final _controller = TextEditingController();

  List<String> getSuggestions(String p) {
    final subjects = ref.read(subjectsController);
    return List.of(subjects)
        .where((option) => option.startsWith(p.split("\n").last.trim()))
        .toList();
  }

  @override
  void initState() {
    _suggestions = getSuggestions("");
    super.initState();
  }

  void _onSuggestionSelect(int idx) {
    final suggestion = _suggestions[idx];
    var lines = _text.split("\n");
    lines.last = suggestion.toString();
    var newText = lines.join("\n");

    _setControllerText(newText);
    _updateText(newText);
  }

  void _setControllerText(String t) {
    _controller.text = t;
    _controller.selection =
        TextSelection.collapsed(offset: t.length, affinity: TextAffinity.downstream);
  }

  void _updateText(String t) {
    setState(() {
      _text = t;
    });

    widget.onTextUpdate(t);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: _suggestions.isEmpty ? 0 : null,
            constraints: const BoxConstraints(maxHeight: 100),
            child: _suggestions.isNotEmpty
                ? NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (overscroll) {
                      overscroll.disallowIndicator();
                      return false;
                    },
                    child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        shrinkWrap: true,
                        itemCount: _suggestions.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                _onSuggestionSelect(index);
                              },
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                  child: Text(_suggestions[index],
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Theme.of(context).colorScheme.tertiary))));
                        }))
                : null),
        TextField(
          controller: _controller,
          onChanged: (t) {
            setState(() {
              _suggestions = getSuggestions(t);
            });
            // Max name length is 20 chars
            if (t.trim().split("\n").last.length > 20) {
              // Set the prev text and set cursor on the end of the text
              // This way we forbid user  to type after 20 chars
              _setControllerText(_text);
              return;
            }

            _updateText(t);
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
              hintStyle: TextStyle(color: Theme.of(context).colorScheme.tertiaryContainer)),
        )
      ],
    );
  }
}
