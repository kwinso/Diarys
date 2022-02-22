import 'package:diarys/components/schedule/add_modal_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../theme/colors.dart';

class AddModal extends StatefulWidget {
  final VoidCallback onCancel;
  final Function(List<String>) onAdd;

  const AddModal({Key? key, required this.onCancel, required this.onAdd}) : super(key: key);

  @override
  State<AddModal> createState() => _AddModalState();
}

// TODO: Do something with setText (set both state and value for field)
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
                  child: AddModalAutocomplete(
                    onTextUpdate: (t) {
                      setState(() {
                        _text = t;
                      });
                    },
                  ),
                  // child: Container(
                  //     constraints: const BoxConstraints(maxHeight: 100),
                  //     child: TypeAheadField(
                  //       // getImmediateSuggestions: true,
                  //       animationDuration: const Duration(milliseconds: 0),
                  //       debounceDuration: const Duration(milliseconds: 0),
                  //       // hideOnEmpty: true,
                  //       keepSuggestionsOnSuggestionSelected: true,
                  //       direction: AxisDirection.up,
                  //       suggestionsBoxDecoration: SuggestionsBoxDecoration(
                  //           constraints: BoxConstraints(maxHeight: 200),
                  //           borderRadius: const BorderRadius.all(Radius.circular(12))),
                  //       textFieldConfiguration: TextFieldConfiguration(
                  //           controller: _controller,
                  //           onChanged: (t) {
                  //             // Max name length is 20 chars
                  //             if (t.trim().split("\n").last.length > 20) {
                  //               // Set the prev text and set cursor on the end of the text
                  //               // This way we forbid user  to type after 20 chars
                  //               _setControllerText(t);
                  //             }

                  //             _updateText(t);
                  //           },
                  //           keyboardType: TextInputType.multiline,
                  //           maxLines: null,
                  //           autofocus: true,
                  //           textCapitalization: TextCapitalization.sentences,
                  //           style: TextStyle(
                  //             color: Theme.of(context).colorScheme.tertiary,
                  //           ),
                  //           decoration: InputDecoration(
                  //               hintText: "Название предмета",
                  //               hintStyle: TextStyle(
                  //                   color: Theme.of(context).colorScheme.tertiaryContainer))),
                  //       suggestionsCallback: (pattern) {
                  //         if (pattern.isNotEmpty) {
                  //           return [
                  //             "Математика",
                  //             "Алгебра",
                  //             "Геометрия",
                  //             "Алгебра",
                  //             "Алгебра",
                  //             "Алгебра",
                  //             "Алгебра",
                  //           ];
                  //         }

                  //         return [];
                  //       },
                  //       itemBuilder: (context, suggestion) {
                  //         return Padding(
                  //             padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  //             child: Container(
                  //               // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  //               child: Text(
                  //                 suggestion.toString(),
                  //                 style: TextStyle(
                  //                     fontSize: 20,
                  //                     color: Theme.of(context).colorScheme.tertiary),
                  //               ),
                  //             ));
                  //       },
                  //       onSuggestionSelected: (suggestion) {
                  //         var lines = _text.split("\n");
                  //         print(lines);
                  //         lines.last = suggestion.toString();
                  //         var newText = lines.join("\n");

                  //         _setControllerText(newText);
                  //         _updateText(newText);
                  //       },
                  //     )
                  // child: TextField(
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: widget.onCancel,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: const BorderRadius.all(Radius.circular(12))),
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: Text(
                            "Отмена",
                            style: TextStyle(
                                fontSize: 15, color: Theme.of(context).colorScheme.tertiary),
                          ),
                        )),
                    TextButton(
                        onPressed: () {
                          if (_text.isNotEmpty) widget.onAdd(_text.trim().split("\n"));
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              color: AppColors.green,
                              borderRadius: BorderRadius.all(Radius.circular(12))),
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: Text(
                            "Добавить",
                            style: TextStyle(
                                fontSize: 15, color: Theme.of(context).colorScheme.tertiary),
                          ),
                        ))
                  ],
                )
              ],
            )));
  }
}
