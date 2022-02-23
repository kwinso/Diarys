import "package:flutter_riverpod/flutter_riverpod.dart";

final subjectsState = StateNotifierProvider<SubjectsNotifier, List<String>>((ref) {
  return SubjectsNotifier([]);
});

class SubjectsNotifier extends StateNotifier<List<String>> {
  SubjectsNotifier(List<String> s) : super(s);

  void addUniqueSubjects(List<String> subjects) {
    for (var subject in subjects) {
      if (!state.contains(subject)) {
        state.add(subject);
      }
    }
  }
}
