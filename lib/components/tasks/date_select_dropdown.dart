import 'package:diarys/components/tasks/calendar.dart';
import 'package:diarys/state/add_task.dart';
import 'package:diarys/state/hive/controllers/subjects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

enum DropdownSelection { nextLesson, calendar, date, tomorrow }
const nextLessonItem = DropdownMenuItem(
  value: DropdownSelection.nextLesson,
  child: DateDropdownItem(
    Icons.skip_next,
    "На следующий урок",
  ),
);
const tomorrowItem = DropdownMenuItem(
  value: DropdownSelection.tomorrow,
  child: DateDropdownItem(
    Icons.skip_next,
    "На завтра",
  ),
);

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
  DropdownSelection _value = DropdownSelection.tomorrow;
  String _lastSubject = "";

  void _setTomorrowDate() {
    ref.read(addTaskController).setDate(DateTime.now().add(const Duration(days: 1)));
    setState(() => _value = DropdownSelection.tomorrow);
  }

  void _setNextLessonDate() {
    ref.read(addTaskController).setNextLessonDate();
    setState(() => _value = DropdownSelection.nextLesson);
  }

  @override
  void didUpdateWidget(oldWidget) {
    final addTask = ref.read(addTaskController);
    final subject = addTask.data.subject;

    if (subject != _lastSubject) {
      _setTomorrowDate();
      setState(() => _lastSubject = subject);
    }

    if (ref.read(subjectsController).contains(widget.subject)) {
      if (_value == DropdownSelection.tomorrow) {
        _setNextLessonDate();
      }
    } else {
      if (_value == DropdownSelection.nextLesson) {
        _setTomorrowDate();
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  List<DropdownMenuItem<DropdownSelection>> _getDropDownItems() {
    final List<DropdownMenuItem<DropdownSelection>> items = [];
    final addTask = ref.read(addTaskController);
    final d = addTask.data.untilDate;

    // If date is selected by user, then show it in dropdown
    // Dates like "nextLesson" or "tomorrow" will be shown as text instead of String with date
    if (_value == DropdownSelection.date) {
      String date = "${d.day}.${d.month.toString().padLeft(2, "0")}.${d.year}";
      items.add(
        DropdownMenuItem(
          value: DropdownSelection.date,
          child: DateDropdownItem(Icons.date_range, date),
        ),
      );
    }

    // If subject exists, we can find a next lesson date for it
    if (ref.read(subjectsController).contains(widget.subject))
      items.add(nextLessonItem);
    else
      items.add(tomorrowItem);

    items.add(const DropdownMenuItem(
      value: DropdownSelection.calendar,
      child: DateDropdownItem(Icons.date_range, "Выбрать на календаре"),
    ));

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton2<DropdownSelection>(
          style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.tertiary),
          value: _value,
          isExpanded: true,
          dropdownDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(12)),
          items: _getDropDownItems(),
          buttonPadding: const EdgeInsets.symmetric(horizontal: 5),
          onChanged: (c) {
            switch (c) {
              case DropdownSelection.calendar:
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
                  ),
                );
                break;
              case DropdownSelection.nextLesson:
                _setNextLessonDate();
                break;
              case DropdownSelection.tomorrow:
                _setTomorrowDate();
                break;
            }
          },
        ),
      ),
    );
  }
}

class DateDropdownItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const DateDropdownItem(
    this.icon,
    this.text, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 5),
          child: Icon(icon),
        ),
        Text(text)
      ],
    );
  }
}
