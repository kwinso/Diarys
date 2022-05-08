import 'package:flutter/material.dart';

class CustomSliverAppBar extends StatelessWidget {
  final Widget child;
  const CustomSliverAppBar(this.child, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      shadowColor: Theme.of(context).shadowColor,
      pinned: true,
      expandedHeight: 50,
      toolbarHeight: 50,
      elevation: 1,
      flexibleSpace: child,
    );
  }
}
