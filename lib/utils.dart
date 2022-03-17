import 'package:diarys/state/hive/controllers/subjects.dart';
import 'package:diarys/theme/colors.dart';
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

  static Color getDifficultyColor(int d) {
    switch (d) {
      case 1:
        return AppColors.green;
      case 2:
        return AppColors.yellow;
      // 3 and (somehow) more (bc 3 is the max)
      default:
        return AppColors.red;
    }
  }

  static String getDifficultyLabel(int d) {
    switch (d) {
      case 1:
        return "Легко";
      case 2:
        return "Средне";
      // 3 and (somehow) more (bc 3 is the max)
      default:
        return "Сложно";
    }
  }
}
