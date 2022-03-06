import 'package:flutter/material.dart';

class RouteBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  const RouteBar({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
          // mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                    ))),
            Text(
              name,
              style: const TextStyle(fontSize: 20),
            ),
          ]),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
