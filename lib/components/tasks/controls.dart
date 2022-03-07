import 'package:diarys/screens/add_task.dart';
import 'package:flutter/material.dart';

class TasksControls extends StatefulWidget {
  TasksControls({Key? key}) : super(key: key);

  @override
  State<TasksControls> createState() => _TasksControlsState();
}

class _TasksControlsState extends State<TasksControls> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ControlButton(
          name: "Все задания",
          icon: Icons.list,
          onClick: () {},
        ),
        _ControlButton(
          name: "Добавить",
          icon: Icons.add,
          onClick: () {
            Navigator.push(context, MaterialPageRoute(builder: (ctx) => const AddTask()));
          },
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  final String name;
  final IconData icon;
  final VoidCallback onClick;
  const _ControlButton({
    Key? key,
    required this.name,
    required this.icon,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.45,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Icon(
                  icon,
                  size: 40,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Text(name)
            ],
          ),
        ),
      ),
    );
  }
}
