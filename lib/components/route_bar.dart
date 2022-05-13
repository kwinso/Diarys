import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RouteBar extends ConsumerWidget implements PreferredSizeWidget {
  final String name;
  final bool sliver;
  // final Color? backgroundColor;
  const RouteBar({
    Key? key,
    required this.name,
    this.sliver = false,
    // this.backgroundColor,
  }) : super(key: key);

  IconButton backButton(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).colorScheme.secondary,
        ));
  }

  Text title() {
    return Text(
      name,
      style: const TextStyle(fontSize: 20),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (sliver) {
      return SliverAppBar(
          pinned: true,
          shadowColor: Theme.of(context).shadowColor,
          leading: backButton(context),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [title()],
          ));
    } else {
      return AppBar(
        elevation: 0,
        leading: backButton(context),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [title()],
        ),
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
