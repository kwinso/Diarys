import 'package:diarys/components/tasks/card.dart';
import 'package:diarys/state/hive/types/task.dart';
import 'package:diarys/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Will not render if [tasks.isEmpty] == [true]
class TasksList extends ConsumerStatefulWidget {
  final String title;
  final List<Task> tasks;
  final String? dateLabel;
  final bool missied;
  const TasksList({
    Key? key,
    required this.title,
    required this.tasks,
    this.dateLabel,
    this.missied = false,
  }) : super(key: key);

  @override
  ConsumerState<TasksList> createState() => _TasksListState();
}

class _TasksListState extends ConsumerState<TasksList> {
  bool _titleHidden = false;
  bool _pendingRemoval = false;

  @override
  void initState() {
    super.initState();
    _titleHidden = widget.tasks.isEmpty;
  }

  @override
  void didUpdateWidget(covariant TasksList oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _titleHidden = (_pendingRemoval && widget.tasks.length == 1) || widget.tasks.isEmpty;
      _pendingRemoval = false;
    });
  }

  Widget _getHeader() {
    final nameLabel = Text(
      widget.title,
      style: TextStyle(fontSize: 23, color: Theme.of(context).colorScheme.tertiaryContainer),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            widget.missied
                ? const Tooltip(
                    child: Icon(Icons.warning_amber_rounded, color: AppColors.red),
                    triggerMode: TooltipTriggerMode.tap,
                    message: "Пропущенный день",
                  )
                : Container(
                    width: 0,
                  ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: nameLabel,
            ),
          ],
        ),
        Text(
          widget.dateLabel ?? "",
          style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.primaryContainer),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: !_titleHidden ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          secondChild: Container(),
          firstChild: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: _getHeader(),
          ),
        ),
        for (var t in widget.tasks)
          TaskCard(
            t,
            key: t.id,
            showDate: widget.dateLabel == null,
            beforeDismiss: (prevRemoved) => setState(() {
              // If removal queue has been with item in it before dissmissal of another item
              // We should wait for the state update in order to determine should title be hidden
              // If the value was first to remove, we can check instantly
              if (prevRemoved)
                _pendingRemoval = true;
              else
                _titleHidden = widget.tasks.length == 1;
            }),
            onUndoDismiss: () => setState(() {
              _pendingRemoval = false;
              _titleHidden = false;
            }),
          )
      ],
    );
  }
}
