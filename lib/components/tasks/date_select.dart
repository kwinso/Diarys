import 'package:flutter/material.dart';

enum DropdownSelection { nextLesson, date }

class TaskDateSelect extends StatefulWidget {
  const TaskDateSelect({Key? key}) : super(key: key);

  @override
  State<TaskDateSelect> createState() => _TaskDateSelectState();
}

class _TaskDateSelectState extends State<TaskDateSelect> {
  DropdownSelection? _value;

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
            items: const [
              DropdownMenuItem(
                  value: DropdownSelection.nextLesson,
                  child: DropdownTile(
                    icon: Icons.skip_next,
                    label: "Следующий урок",
                  )),
              // TODO: Make dynamic
              DropdownMenuItem(
                value: DropdownSelection.date,
                child: DropdownTile(
                  icon: Icons.date_range,
                  label: "12.01.2022",
                ),
              ),
              // for (var i = 0; i < 30; i++)
              //   DropdownMenuItem(
              //     // alignment: Alignment.center,
              //     value: i.toString(),
              //     child: Text("Tile N$i"),
              //   )
            ],
            onChanged: (c) => setState(() => _value = c),
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
