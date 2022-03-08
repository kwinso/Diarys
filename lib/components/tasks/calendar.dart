import 'package:flutter/material.dart';

class TaskDateSelectCalendar extends StatefulWidget {
  const TaskDateSelectCalendar({Key? key}) : super(key: key);

  @override
  State<TaskDateSelectCalendar> createState() => _TaskDateSelectCalendarState();
}

class _TaskDateSelectCalendarState extends State<TaskDateSelectCalendar> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // * Uncomment to have dynamic localization
          // Localizations.override(
          //   context: context,
          //   locale: Locale("ru"),
          //   child:
          CalendarDatePicker(
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2030, 1, 1),
            onDateChanged: (d) {
              print(d);
            },
          ),
          // ),
          TextButton(
              // TODO:
              onPressed: () {},
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: const BorderRadius.all(Radius.circular(12))),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Text(
                  "Save",
                  style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.tertiary),
                ),
              )),
        ],
      ),
    );
  }
}
