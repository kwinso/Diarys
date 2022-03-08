import 'package:diarys/components/tasks/calendar.dart';
import 'package:diarys/state/subjects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

enum DropdownSelection { nextLesson, calendar, date }

class TaskDateSelect extends ConsumerStatefulWidget {
  final String subject;
  const TaskDateSelect({
    Key? key,
    required this.subject,
  }) : super(key: key);

  @override
  _TaskDateSelectState createState() => _TaskDateSelectState();
}

const nextLessonItem = DropdownMenuItem(
    value: DropdownSelection.nextLesson,
    child: DropdownTile(
      icon: Icons.skip_next,
      label: "Следующий урок",
    ));

class _TaskDateSelectState extends ConsumerState<TaskDateSelect> {
  DropdownSelection? _value;

  List<DropdownMenuItem<DropdownSelection>> _getDropdownItems() {
    final List<DropdownMenuItem<DropdownSelection>> items = [];
    // If subject exists, we can find a next lesson date for it
    if (ref.read(subjectsController).state.list.any((e) {
      return e.name == widget.subject;
    })) {
      items.add(nextLessonItem);
    }

    items.add(const DropdownMenuItem(
      value: DropdownSelection.calendar,
      child: DropdownTile(
        icon: Icons.date_range,
        label: "Выбрать на календаре",
      ),
    ));

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 10,
      ),
      decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.primaryContainer,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<DropdownSelection>(
            hint: const DropdownTile(
              label: "Выберите дату",
              icon: Icons.date_range,
            ),
            isExpanded: true,
            value: _value,
            dropdownColor: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12),
            items: _getDropdownItems(),
            onChanged: (c) {
              if (c == DropdownSelection.calendar) {
                // showDatePicker(
                //     context: context,
                //     locale: Locale("ru"),
                //     initialDate: DateTime.now(),
                //     firstDate: DateTime.now(),
                //     lastDate: DateTime(2030, 1, 1));
                showMaterialModalBottomSheet(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Theme.of(context).backgroundColor,
                    context: context,
                    builder: (c) => TaskDateSelectCalendar());
              }
            },
          ),
        ),
      ),
    );
  }
}

class DropdownTile extends StatelessWidget {
  final String label;
  final IconData icon;
  const DropdownTile({
    Key? key,
    required this.label,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.tertiaryContainer,
          ),
        ),
        Text(label),
      ],
    );
  }
}
