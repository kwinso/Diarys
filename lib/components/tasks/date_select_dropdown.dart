import 'package:diarys/components/tasks/calendar.dart';
import 'package:diarys/state/subjects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

enum DropdownSelection { nextLesson, calendar, date }
const nextLessonItem =
    DropdownMenuItem(value: DropdownSelection.nextLesson, child: Text("На следующий урок"));

class DateSelectDropdown extends ConsumerStatefulWidget {
  final String lesson;
  const DateSelectDropdown({
    Key? key,
    required this.lesson,
  }) : super(key: key);

  @override
  _DateSelectButtonState createState() => _DateSelectButtonState();
}

class _DateSelectButtonState extends ConsumerState<DateSelectDropdown> {
  DropdownSelection? _value;

  List<DropdownMenuItem<DropdownSelection>> _getDropdownItems() {
    final List<DropdownMenuItem<DropdownSelection>> items = [];
    // If subject exists, we can find a next lesson date for it
    if (ref.read(subjectsController).state.list.any((e) {
      return e.name == widget.lesson;
    })) {
      items.add(nextLessonItem);
    }

    items.add(const DropdownMenuItem(
      value: DropdownSelection.calendar,
      child: Text("Выбрать на календаре"),
    ));

    return items;
  }

  Text _getHint(String t) {
    return Text(t, style: TextStyle(color: Theme.of(context).colorScheme.tertiaryContainer));
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton<DropdownSelection>(
          style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.tertiary),
          disabledHint: _getHint("Предмет обязателен"),
          hint: _getHint("Дата"),
          value: _value,
          isExpanded: true,
          dropdownColor: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(12),
          items: widget.lesson.isNotEmpty ? _getDropdownItems() : [],
          onChanged: (c) {
            // setState(() {
            //   _value = c;
            // });
            if (c == DropdownSelection.calendar) {
              showMaterialModalBottomSheet(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Theme.of(context).backgroundColor,
                  context: context,
                  builder: (c) => TaskDateSelectCalendar(
                        lesson: widget.lesson,
                        onSubmit: () {
                          Navigator.pop(c);
                        },
                      ));
            }
          },
        ),
      ),
    );
  }
}
