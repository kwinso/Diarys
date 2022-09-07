import 'package:diarys/components/elevated_button.dart';
import 'package:diarys/state/hive/controllers/subjects.dart';
import 'package:diarys/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AppUtils {
  static List<String> getSubjectSuggestions(WidgetRef ref, String t, bool emptyIfNoText) {
    final line = t.split("\n").last.trim().toLowerCase();
    if (line.isEmpty && emptyIfNoText) return [];

    return ref
        .read(subjectsController)
        .state
        .list
        .reversed
        .where((option) {
          final name = option.name.toLowerCase();
          // Starts with but not equal
          return name.startsWith(line);
        })
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
        return "Сложноe";
    }
  }

  static String getDifficultyEmoji(int d) {
    switch (d) {
      case 1:
        return "👌";
      case 2:
        return "😀";
      // 3 and (somehow) more (bc 3 is the max)
      default:
        return "😓";
    }
  }

  static String formatDate(DateTime d) =>
      "${d.day.toString().padLeft(2, "0")}.${d.month.toString().padLeft(2, "0")}.${d.year}";

  // static addOneDayToDate(DateTime d) => d.add(const Duration(days: 1));
  static getTomorrowDate() => DateTime.now().add(const Duration(days: 1));

  static Future<bool> showAppDialog(
    BuildContext context, {
    required String title,
    required String confirmButtonText,
    required Color confirmButtonColor,
    String? description,
    VoidCallback? onConfirm,
  }) async {
    var res = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: description != null ? Text(description) : null,
            titleTextStyle: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.tertiary),
            contentTextStyle:
                TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.tertiary),
            backgroundColor: Theme.of(context).backgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            actions: [
              AppElevatedButton(
                text: confirmButtonText,
                color: confirmButtonColor,
                foregroundColor: Colors.white,
                onPressed: () {
                  onConfirm?.call();
                  Navigator.of(context).pop(true);
                },
              ),
              AppElevatedButton(
                text: "Отмена",
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ],
          );
        });

    return res ?? false;
  }

  static void showSnackBar(
    BuildContext ctx, {
    required String text,
    Color? backgroundColor,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(ctx).clearSnackBars();
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.horizontal,
        duration: const Duration(seconds: 3),
        backgroundColor: backgroundColor,
        content: Text(
          text,
          style: TextStyle(
            color: Theme.of(ctx).colorScheme.tertiary,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        action: action,
        // content: Text("Хранилище очищено"),
      ),
    );
  }

  static void showBottomSheet({
    required BuildContext context,
    required Widget Function(BuildContext) builder,
    Key? key,
  }) {
    showMaterialModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      context: context,
      builder: (ctx) => SingleChildScrollView(
        key: key,
        child: Container(
          padding: EdgeInsets.only(
            left: 15,
            right: 15,
            top: 15,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 15,
          ),
          child: builder(ctx),
        ),
      ),
    );
  }
}
