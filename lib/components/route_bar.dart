import 'package:flutter/material.dart';

class RouteBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final bool sliver;
  const RouteBar({
    Key? key,
    required this.name,
    this.sliver = false,
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
  Widget build(BuildContext context) {
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
      return Container(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [backButton(context), title()],
          ),
        ),
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
