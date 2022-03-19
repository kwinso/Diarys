import 'package:diarys/components/tasks/calendar.dart';
import 'package:diarys/state/add_task.dart';
import 'package:diarys/state/hive/controllers/subjects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

enum DropdownSelection { nextLesson, calendar, date }
const nextLessonItem =
    DropdownMenuItem(value: DropdownSelection.nextLesson, child: Text("На следующий урок"));

class DateSelectDropdown extends ConsumerStatefulWidget {
  final String subject;
  const DateSelectDropdown({
    Key? key,
    required this.subject,
  }) : super(key: key);

  @override
  _DateSelectButtonState createState() => _DateSelectButtonState();
}

class _DateSelectButtonState extends ConsumerState<DateSelectDropdown> {
  DropdownSelection? _value;

  List<DropdownMenuItem<DropdownSelection>> _getDropdownItems(DateTime? d) {
    final List<DropdownMenuItem<DropdownSelection>> items = [];
    // If subject exists, we can find a next lesson date for it
    if (ref.read(subjectsController).state.list.any((e) {
      return e.name == widget.subject;
    })) {
      items.add(nextLessonItem);
    }

    items.add(const DropdownMenuItem(
      value: DropdownSelection.calendar,
      child: Text("Выбрать на календаре"),
    ));

    if (d != null) {
      String date = "${d.day}.${d.month.toString().padLeft(2, "0")}.${d.year}";
      items.add(
        DropdownMenuItem(
          value: DropdownSelection.date,
          child: Text(date),
        ),
      );
    }

    return items;
  }

  Text _getHint(String t) {
    return Text(t, style: TextStyle(color: Theme.of(context).colorScheme.tertiaryContainer));
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(addTaskController).data.untilDate;
    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton2<DropdownSelection>(
          style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.tertiary),
          // disabledHint: _getHint("Предмет обязателен"),
          hint: _getHint("Дата"),
          value: _value,
          isExpanded: true,
          dropdownDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(12)),
          items: _getDropdownItems(selectedDate),
          buttonPadding: EdgeInsets.symmetric(horizontal: 5),
          onChanged: (c) {
            if (c == DropdownSelection.calendar) {
              showMaterialModalBottomSheet(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Theme.of(context).backgroundColor,
                  context: context,
                  builder: (c) => TaskDateSelectCalendar(
                        lesson: widget.subject,
                        onSubmit: (d) {
                          ref.read(addTaskController).setDate(d);
                          setState(() => _value = DropdownSelection.date);
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
