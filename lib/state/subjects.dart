import 'package:diarys/state/db_service.dart';
import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";

final subjectsController = ChangeNotifierProvider<SubjectsController>((ref) {
  final _db = ref.watch(databaseService);

  return SubjectsController(_db);
});

class SubjectsController with ChangeNotifier {
  late final DatabaseService _db;

  SubjectsController(this._db);

  List<String> get state => _db.lessonsList;

  void addUniqueSubjects(List<String> subjects) {
    for (var subject in subjects) {
      if (!state.contains(subject)) {
        state.add(subject);
      }
    }
    notifyListeners();
  }
}
