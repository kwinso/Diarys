import 'package:diarys/state/hive/controllers/schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class TaskDateSelectCalendar extends ConsumerStatefulWidget {
  // TODO: Add param with selected date to callback
  final Function(DateTime d) onSubmit;
  final String lesson;
  const TaskDateSelectCalendar({
    Key? key,
    required this.onSubmit,
    required this.lesson,
  }) : super(key: key);

  @override
  _TaskDateSelectCalendarState createState() => _TaskDateSelectCalendarState();
}

class _TaskDateSelectCalendarState extends ConsumerState<TaskDateSelectCalendar> {
  DateTime? _date = null;

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _CustomCalendar(
            selected: _date ?? DateTime.now(),
            allowedDays: ref.read(scheduleController).getDaysContainingLesson(widget.lesson),
            onSelect: (d) => setState(() => _date = d),
          ),
          TextButton(
              // TODO:
              onPressed: () {
                if (_date != null) widget.onSubmit(_date!);
              },
              child: Opacity(
                opacity: _date != null ? 1 : 0.5,
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: const BorderRadius.all(Radius.circular(12))),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: const Text(
                    "Сохранить",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final schedule = ref.read(scheduleController);

    if (schedule.isReady) return _buildContent();

    return FutureBuilder(
      future: schedule.initBox(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildContent();
        }
        return Container();
      },
    );
  }

  @override
  void deactivate() {
    ref.read(scheduleController).closeBox();
    super.deactivate();
  }
}

class _CustomCalendar extends StatelessWidget {
  final List<int> allowedDays;
  final DateTime selected;
  final Function(DateTime d) onSelect;
  const _CustomCalendar({
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
        if (isSameDay(d, now)) return false;
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
