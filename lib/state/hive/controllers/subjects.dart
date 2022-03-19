import 'package:diarys/state/hive_notifier.dart';
import 'package:diarys/state/hive/types/subject.dart';
import 'package:diarys/state/hive/types/subjects_list.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:hive/hive.dart';

final subjectsController = ChangeNotifierProvider<SubjectsController>((ref) {
  return SubjectsController();
});

class SubjectsController extends HiveChangeNotifier<SubjectsList> {
  SubjectsController() : super("subjects");

  SubjectsList get state => SubjectsList(box.values.first.list);

  @override
  dynamic emptyBoxFill(Box<SubjectsList> box) {
    box.add(SubjectsList([]));
  }

  bool contains(String subject) => state.list.any((e) => e.name == subject);

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

    updateBox(SubjectsList(updated));
  }

  void removeSubjectRefs(List<String> names) {
    final updated = state.list
        .map((e) {
          if (names.contains(e.name)) e.refs -= names.where((name) => name == e.name).length;
          return e;
        })
        .where((e) => e.refs > 0)
        .toList();

    updateBox(SubjectsList(updated));
  }
}
