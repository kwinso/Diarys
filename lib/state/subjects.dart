import 'package:diarys/state/db_service.dart';
import 'package:diarys/state/hive_types/subject.dart';
import 'package:diarys/state/hive_types/subjects_list.dart';
import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";

final subjectsController = ChangeNotifierProvider<SubjectsController>((ref) {
  final _db = ref.watch(databaseService);

  return SubjectsController(_db);
});

class SubjectsController with ChangeNotifier {
  late final DatabaseService _db;

  SubjectsController(this._db);

  SubjectsList get state => _db.subjects;

  void _updateState(List<Subject> s) {
    _db.updateSubjects(SubjectsList(s));
    notifyListeners();
  }

  void addSubjectsOrRefs(List<String> names) {
    final updated = state.list;
    for (var name in names) {
      if (name.isNotEmpty) {
        final foundIndex = updated.indexWhere((s) => s.name == name);
        if (foundIndex != -1) {
          updated[foundIndex].refs += 1;
        } else {
          updated.add(Subject(name, 1));
        }
      }
    }
    _updateState(updated);
  }

  void removeSubjectRefs(List<String> names) {
    final updated = state.list
        .map((e) {
          if (names.contains(e.name)) e.refs -= names.where((name) => name == e.name).length;
          return e;
        })
        .where((e) => e.refs > 0)
        .toList();

    _updateState(updated);
  }
}
