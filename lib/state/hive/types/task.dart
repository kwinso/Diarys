import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part "task.g.dart";

@HiveType(typeId: 6)
class Task {
  @HiveField(0)
  String subject;

  @HiveField(1)
  DateTime untilDate;

  @HiveField(2)
  int difficulty;

  @HiveField(3)
  String content;

  late UniqueKey id;

  Task({
    required this.subject,
    required this.difficulty,
    required this.content,
    required this.untilDate,
  }) {
    id = UniqueKey();
  }
}
