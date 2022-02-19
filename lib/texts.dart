import 'package:flutter/material.dart';

@immutable
class _Week {
  final List<String> days = const <String>[
    "Понедельник",
    "Вторник",
    "Среда",
    "Четверг",
    "Пятница",
    "Суббота",
    "Воскресенье",
  ];

  const _Week();
}

@immutable
class AppTexts {
  static const _Week week = _Week();
}
