import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Routing {
  static void push(
    BuildContext context,
    Route<dynamic> route, {
    Color? overlayColor,
    Color? popOverlayColor,
  }) async {
    _changeSystemColor(overlayColor);
    Navigator.push(
      context,
      route,
    ).then((res) {
      _changeSystemColor(popOverlayColor);
    });
  }

  static void _changeSystemColor(Color? overlayColor) {
    if (overlayColor != null)
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
            systemNavigationBarColor: overlayColor,
            statusBarColor: overlayColor,
            statusBarBrightness: Brightness.dark),
      );
  }
}
