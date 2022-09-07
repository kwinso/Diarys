import 'package:diarys/state/hive/controllers/hive_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HiveControllersInit extends ConsumerStatefulWidget {
  final List<ChangeNotifierProvider<HiveChangeNotifier>> controllers;
  final Widget Function() build;
  const HiveControllersInit({
    Key? key,
    required this.controllers,
    required this.build,
  }) : super(key: key);

  @override
  _ControllersInitState createState() => _ControllersInitState();
}

class _ControllersInitState extends ConsumerState<HiveControllersInit> {
  bool _subscribed = false;

  Future<void> _init() async {
    for (var c in widget.controllers) {
      await ref.read(c).subscribe();
    }

    // Widget is ready to be used since it's subscribed to all controllers
    _subscribed = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_subscribed) {
      bool allReady = widget.controllers.every((c) => ref.watch(c).isReady);
      if (allReady) return widget.build();
    }

    return FutureBuilder(
      future: _init(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return widget.build();
        }
        return Container();
      },
    );
  }

  @override
  void deactivate() {
    for (var c in widget.controllers) {
      ref.read(c).unsubscribe();
    }
    super.deactivate();
  }
}
