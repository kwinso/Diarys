import 'package:diarys/components/add_task/calendar.dart';
import 'package:diarys/state/add_task.dart';
import 'package:diarys/state/hive/controllers/subjects.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  const DateSelectDropdown({
    Key? key,
  }) : super(key: key);

  @override
  _DateSelectButtonState createState() => _DateSelectButtonState();
}

class _DateSelectButtonState extends ConsumerState<DateSelectDropdown> {
  DropdownSelection _value = DropdownSelection.tomorrow;

  void _setTomorrowDate() {
    ref.read(addTaskController).setDate(DateTime.now().add(const Duration(days: 1)));
    _value = DropdownSelection.tomorrow;
  }

  void _setNextLessonDate() {
    ref.read(addTaskController).setNextLessonDate();
    _value = DropdownSelection.nextLesson;
  }

  List<DropdownMenuItem<DropdownSelection>> _getDropDownItems(AddTaskController addTask) {
    final List<DropdownMenuItem<DropdownSelection>> items = [];
    final d = addTask.data.untilDate;
    final subject = addTask.data.subject;

    // If date is selected by user, then show it in dropdown
    // Dates like "nextLesson" or "tomorrow" will be shown as text instead of String with date
    if (_value == DropdownSelection.date) {
      String date = AppUtils.formatDate(d);
      items.add(
        DropdownMenuItem(
          value: DropdownSelection.date,
          child: DateDropdownItem(Icons.date_range, date),
        ),
      );
    }
    // If subject exists, we can find a next lesson date for it
    if (ref.read(subjectsController).exists(subject)) {
      if (_value == DropdownSelection.tomorrow) {
        _setNextLessonDate();
      }
      items.add(nextLessonItem);
    } else {
      items.add(tomorrowItem);
      if (_value == DropdownSelection.nextLesson) {
        _setTomorrowDate();
      }
    }

    items.add(const DropdownMenuItem(
      value: DropdownSelection.calendar,
      child: DateDropdownItem(Icons.date_range, "Выбрать на календаре"),
    ));

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final addTask = ref.watch(addTaskController);
    final items = _getDropDownItems(addTask);

    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton2<DropdownSelection>(
          style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.tertiary),
          value: _value,
          isExpanded: true,
          dropdownDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(12)),
          items: items,
          buttonPadding: const EdgeInsets.symmetric(horizontal: 5),
          onChanged: (c) {
            switch (c) {
              case DropdownSelection.calendar:
                AppUtils.showBottomSheet(
                  context: context,
                  builder: (c) => TaskDateSelectCalendar(
                    lesson: ref.read(addTaskController).data.subject,
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
              default:
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
          padding: const EdgeInsets.only(right: 5),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.tertiaryContainer,
          ),
        ),
        Text(text)
      ],
    );
  }
}
