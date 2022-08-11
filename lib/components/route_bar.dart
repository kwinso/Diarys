import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RouteBar extends ConsumerWidget implements PreferredSizeWidget {
  final String name;
  final bool sliver;
  final VoidCallback? onBackButton;
  const RouteBar({Key? key, required this.name, this.sliver = false, this.onBackButton})
      : super(key: key);

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
          iconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [title()],
          ));
    } else {
      return AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
        leading: IconButton(
          onPressed: () {
            if (onBackButton != null)
              onBackButton!();
            else
              Navigator.maybePop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
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
