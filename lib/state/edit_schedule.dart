import 'package:diarys/state/hive/controllers/schedule.dart';
import 'package:diarys/state/types/delete_entry.dart';
import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";

final scheduleEditController = ChangeNotifierProvider<EditModeController>((ref) {
  return EditModeController(ref);
});

class EditModeController with ChangeNotifier {
  final Ref _ref;
  bool _active = false;
  List<DeleteEntry> _selectedItems = [];

  EditModeController(this._ref);

  bool get active => _active;
  set active(bool v) {
    _active = v;
    notifyListeners();
  }

  List<DeleteEntry> get selectedItems => _selectedItems;
  set selectedItems(List<DeleteEntry> items) {
    _selectedItems = items;
    notifyListeners();
  }

  void clearSelected() {
    _selectedItems.clear();
    notifyListeners();
  }

  void deleteSelected() {
    _ref.read(scheduleController).removeLessons(_selectedItems);
    _selectedItems.clear();
    notifyListeners();
  }
}
