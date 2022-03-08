import 'package:flutter/material.dart';

class DifficultyTile extends StatelessWidget {
  final String label;
  final Color color;
  final int difficulty;
  final bool isSelected;
  final Function() onSelect;
  const DifficultyTile({
    Key? key,
    required this.label,
    required this.color,
    required this.difficulty,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            // width: 25,
            height: 25,
            margin: const EdgeInsets.only(bottom: 5, right: 5, left: 5),
            decoration: BoxDecoration(
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(100),
              color: isSelected ? color : Colors.transparent,
            ),
          ),
          Text(
            label,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }
}
