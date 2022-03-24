import 'package:flutter/material.dart';

class AppElevatedButton extends StatelessWidget {
  final String text;
  final Color? foregroundColor;
  final Color? color;
  final VoidCallback onPressed;
  const AppElevatedButton({
    Key? key,
    required this.text,
    this.color,
    this.foregroundColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        foregroundColor:
            MaterialStateProperty.all(foregroundColor ?? Theme.of(context).colorScheme.tertiary),
        backgroundColor: MaterialStateProperty.all(color ?? Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
