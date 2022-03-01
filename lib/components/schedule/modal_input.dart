import 'package:diarys/state/subjects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModalAutoCompleteInput extends ConsumerStatefulWidget {
  final Function(String text)? onTextUpdate;
  final Function(String text)? onSubmit;
  final bool multiline;
  final String value;
  const ModalAutoCompleteInput({
    Key? key,
    this.value = "",
    this.multiline = false,
    this.onTextUpdate,
    this.onSubmit,
  }) : super(key: key);

  @override
  _AddModalAutocompleteState createState() => _AddModalAutocompleteState();
}

class _AddModalAutocompleteState extends ConsumerState<ModalAutoCompleteInput> {
  String _text = "";
  List<String> _suggestions = [];
  final _controller = TextEditingController();
  final _inputScrollController = ScrollController();

  @override
  void initState() {
    _text = widget.value;
    _setControllerText(_text);
    _suggestions = _getSuggestions("");
    super.initState();
  }

  List<String> _getSuggestions(String p) {
    final line = p.split("\n").last.trim();
    if (line.isEmpty) return [];

    return ref
        .read(subjectsController)
        .state
        .list
        .reversed
        .where((option) => option.name.startsWith(line))
        .map((e) => e.name)
        .toList();
  }

  void _scrollInputToBottom() {
    // Scroll a little more than max to be sure it's at the bottom
    _inputScrollController.animateTo(_inputScrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 1), curve: Curves.easeOut);
  }

  void _onSuggestionSelect(int idx) {
    final suggestion = _suggestions[idx];
    var newText = suggestion;
    if (widget.multiline) {
      var lines = _text.split("\n");
      lines.last = suggestion.toString() + "\n";
      newText = lines.join("\n");
    }

    _setControllerText(newText);
    _updateText(newText);
    _scrollInputToBottom();
  }

  void _setControllerText(String t) {
    _controller.text = t;
    _controller.selection = TextSelection.collapsed(
      offset: t.length,
    );
  }

  void _updateText(String t) {
    setState(() {
      _text = t;
    });

    widget.onTextUpdate!(t);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: Container(
                height: _suggestions.isEmpty ? 0 : null,
                constraints: const BoxConstraints(maxHeight: 100),
                child: _suggestions.isNotEmpty
                    ? RawScrollbar(
                        thumbColor: Theme.of(context).primaryColor,
                        thickness: 2,
                        isAlwaysShown: true,
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
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                      child: Text(_suggestions[index],
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Theme.of(context).colorScheme.tertiary))));
                            }))
                    : null)),
        Container(
            constraints: const BoxConstraints(maxHeight: 80),
            child: ListView(
                controller: _inputScrollController,
                padding: const EdgeInsets.symmetric(vertical: 0),
                shrinkWrap: true,
                children: [
                  TextField(
                    controller: _controller,
                    onChanged: (t) {
                      if (t.endsWith("\n")) {
                        _scrollInputToBottom();
                      }
                      setState(() {
                        _suggestions = _getSuggestions(t);
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
                    onSubmitted: widget.onSubmit,
                    keyboardType: widget.multiline ? TextInputType.multiline : TextInputType.text,
                    maxLines: null,
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    decoration: InputDecoration(
                        hintText: "Название предмета",
                        // border: BorderSide(),
                        hintStyle:
                            TextStyle(color: Theme.of(context).colorScheme.tertiaryContainer)),
                  )
                ])),
      ],
    );
  }
}
