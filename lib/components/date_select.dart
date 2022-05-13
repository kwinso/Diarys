import 'package:diarys/components/elevated_button.dart';
import 'package:diarys/state/hive/controllers/schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class DateSelectCalendar extends ConsumerStatefulWidget {
  final Function(DateTime d) onSubmit;
  final String subject;
  final DateTime? selected;
  const DateSelectCalendar({Key? key, required this.onSubmit, required this.subject, this.selected})
      : super(key: key);

  @override
  _DateSelectCalendarState createState() => _DateSelectCalendarState();
}

class _DateSelectCalendarState extends ConsumerState<DateSelectCalendar> {
  DateTime? _date;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _date = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppCalendarDatePicker(
          selected: _date ?? DateTime.now(),
          allowedDays: ref.read(scheduleController).getDaysContainingLesson(widget.subject),
          onSelect: (d) => setState(() => _date = d),
        ),
        Opacity(
          opacity: _date != null ? 1 : 0.5,
          child: AppElevatedButton(
            color: Theme.of(context).colorScheme.secondary,
            foregroundColor: Colors.white,
            onPressed: () {
              if (_date != null) widget.onSubmit(_date!);
            },
            text: 'Сохранить',
          ),
        ),
      ],
    );
  }
}

class AppCalendarDatePicker extends StatelessWidget {
  final List<int> allowedDays;
  final DateTime selected;
  final Function(DateTime d) onSelect;
  const AppCalendarDatePicker({
    Key? key,
    required this.allowedDays,
    required this.selected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return TableCalendar(
      calendarFormat: CalendarFormat.month,
      startingDayOfWeek: StartingDayOfWeek.monday,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        leftChevronIcon: Icon(Icons.chevron_left, color: Theme.of(context).colorScheme.tertiary),
        rightChevronIcon: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.tertiary),
      ),
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          shape: BoxShape.circle,
          // borderRadius: BorderRadius.circular(100),
        ),
        defaultTextStyle: TextStyle(color: Theme.of(context).colorScheme.tertiary),
        weekendTextStyle: TextStyle(color: Theme.of(context).colorScheme.tertiary),
        disabledTextStyle: TextStyle(color: Theme.of(context).colorScheme.primaryContainer),
        outsideDaysVisible: false,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle(color: Theme.of(context).colorScheme.tertiaryContainer),
        weekdayStyle: TextStyle(color: Theme.of(context).colorScheme.tertiaryContainer),
      ),
      pageAnimationDuration: const Duration(milliseconds: 300),
      focusedDay: selected,
      enabledDayPredicate: (d) {
        if (isSameDay(d, now)) return true;
        if (isSameDay(d, selected)) return true;
        return allowedDays.isNotEmpty ? allowedDays.contains(d.weekday - 1) : true;
      },
      selectedDayPredicate: (d) => isSameDay(d, selected),
      holidayPredicate: (d) => false,
      firstDay: now,
      locale: Localizations.localeOf(context).languageCode,
      lastDay: DateTime(now.year + 1),
      onDaySelected: (selected, _) {
        onSelect(selected);
      },
    );
  }
}
