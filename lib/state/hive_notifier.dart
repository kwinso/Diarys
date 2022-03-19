import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HiveChangeNotifier<T> with ChangeNotifier {
  final String _name;
  @protected
  late Box<T> box;

  HiveChangeNotifier(this._name);

  bool get isReady {
    try {
      return box.isOpen;
    } catch (e) {
      return false;
    }
  }

  @protected
  // A placeholder for writing a value to opened box if it's empty
  dynamic emptyBoxFill(Box<T> box) => null;

  /// [fill] runs if opened box is empty
  Future<void> initBox() async {
    if (isReady) return;
    await Hive.openBox<T>(_name).then((v) => box = v);
    if (box.values.isEmpty) emptyBoxFill(box);
  }

  /// Updates first box value to [v]
  @protected
  Future<void> updateBox(T v) async {
    await box.put(0, v);
    notifyListeners();
  }

  /// Closes the box
  Future<void> closeBox() async => await box.close();
}
