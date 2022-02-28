import 'package:diarys/state/db_service.dart';
import 'package:diarys/state/types/subject.dart';
import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";

final subjectsController = ChangeNotifierProvider<SubjectsController>((ref) {
  final _db = ref.watch(databaseService);

  return SubjectsController(_db);
});

class SubjectsController with ChangeNotifier {
  late final DatabaseService _db;

  SubjectsController(this._db);

  List<Subject> get state => _db.lessons;

  void _updateState(List<Subject> s) {
    _db.updateSubjects(s);
    notifyListeners();
  }

  void addSubjects(List<String> names) {
    final updated = state;
    for (var name in names) {
      final foundIndex = updated.indexWhere((s) => s.name == name);
      if (foundIndex != -1) {
        updated[foundIndex].refs += 1;
      } else {
        updated.add(Subject(name, 1));
      }
    }
    _updateState(updated);
  }

  void removeSubjectRefs(List<String> names) {
    final updated = state
        .map((e) {
          if (names.contains(e.name)) e.refs -= 1;
          return e;
        })
        .where((e) => e.refs > 0)
        .toList();

    _updateState(updated);
  }
}
