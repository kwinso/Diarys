import 'package:diarys/state/subjects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppUtils {
  static List<String> getSubjectSuggestions(WidgetRef ref, String t, bool emptyIfNoText) {
    final line = t.split("\n").last.trim();
    if (line.isEmpty && emptyIfNoText) return [];

    return ref
        .read(subjectsController)
        .state
        .list
        .reversed
        .where((option) => option.name.toLowerCase().startsWith(line.toLowerCase()))
        .map((e) => e.name)
        .toList();
  }
}
