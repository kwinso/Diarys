import 'package:diarys/components/add_task/calendar.dart';
import 'package:diarys/state/add_task.dart';
import 'package:diarys/state/hive/controllers/subjects.dart';
import 'package:diarys/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:table_calendar/table_calendar.dart';

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
    ref.read(addTaskController).untilDate = AppUtils.getTomorrowDate();
    _value = DropdownSelection.tomorrow;
  }

  void _setNextLessonDate() {
    ref.read(addTaskController).setNextLessonDate();
    _value = DropdownSelection.nextLesson;
  }

  List<DropdownMenuItem<DropdownSelection>> _getDropDownItems() {
    final List<DropdownMenuItem<DropdownSelection>> items = [];
    final addTask = ref.read(addTaskController);

    // If date is selected by user, then show it in dropdown
    // Dates like "nextLesson" or "tomorrow" will be shown as text instead of String with date
    if (_value == DropdownSelection.date) {
      String d = AppUtils.formatDate(addTask.untilDate);
      items.add(
        DropdownMenuItem(
          value: DropdownSelection.date,
          child: DateDropdownItem(Icons.date_range, d),
        ),
      );
    } else {
      // If subject exists, we can find a next lesson date for it
      if (ref.read(addTaskController).subjectInSchedule) {
        _value = DropdownSelection.nextLesson;
        items.add(nextLessonItem);
      } else {
        _value = DropdownSelection.tomorrow;
        items.add(tomorrowItem);
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
    ref.watch(addTaskController.select((v) => v.subject));
    // Subject changed: Set value to default to process it again
    _value = DropdownSelection.tomorrow;

    final items = _getDropDownItems();

    return DropdownButtonHideUnderline(
      child: DropdownButton2<DropdownSelection>(
        style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.tertiary),
        value: _value,
        isExpanded: true,
        dropdownDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(12)),
        items: items,
        buttonDecoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.primaryContainer,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        focusColor: Theme.of(context).colorScheme.primary,
        buttonPadding: const EdgeInsets.symmetric(horizontal: 5),
        onChanged: (c) {
          switch (c) {
            case DropdownSelection.calendar:
              AppUtils.showBottomSheet(
                context: context,
                builder: (c) => TaskDateSelectCalendar(
                  onSubmit: (d) {
                    ref.read(addTaskController).untilDate = d;
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
