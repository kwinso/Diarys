import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HiveChangeNotifier<T> with ChangeNotifier {
  final String _name;
  @protected
  late Box<T> box;
  // Amount of times box was requested to init (describes how many listeners depend on this box)
  int _subs = 0;

  HiveChangeNotifier(this._name);

  bool get isReady {
    try {
      return box.isOpen;
    } catch (e) {
      return false;
    }
  }

  // A placeholder for writing a value to opened box if it's empty
  @protected
  Future<dynamic> emptyBoxFill(Box<T> box) async {}

  /// [fill] runs if opened box is empty
  Future<void> _initBox() async {
    if (isReady) return;

    await Hive.openBox<T>(_name).then((v) => box = v);
    if (box.values.isEmpty) await emptyBoxFill(box);
  }

  /// Updates first box value to [v]
  @protected
  Future<void> updateBox(T v) async {
    await box.put(0, v);
    notifyListeners();
  }

  // Clears values in box and fills it with default values
  Future<void> emptyBox() async {
    if (isReady) {
      await box.clear();
      await emptyBoxFill(box);
      notifyListeners();
    }
  }

  Future<void> subscribe() async {
    _subs += 1;
    await _initBox();
  }

  /// Removes the subscription and closes the box when no subscriptions for box is left
  void unsubscribe() async {
    _subs -= 1;
    // Because many places can depend on one box,
    // closing box is safe only there's no subscribers
    if (_subs <= 0) {
      try {
        _subs = 0;
        await box.close();
        notifyListeners();
      } catch (e) {
        // pass...
      }
    }
  }
}
