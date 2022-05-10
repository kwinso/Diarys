import 'package:diarys/screens/settings.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height = 50;

  const MainAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Remove flexible space, use CenterTitle and Actions
    return SliverAppBar(
      automaticallyImplyLeading: false,
      shadowColor: Theme.of(context).shadowColor,
      centerTitle: true,
      title: Text(
        "Diarys",
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.primaryContainer,
          fontFamily: "RubikMonoOne",
        ),
      ),
      actions: [
        IconButton(
            tooltip: "Настройки",
            splashRadius: 1,
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (ctx) => const SettingsScreen())),
            icon: Icon(
              Icons.settings_rounded,
              color: Theme.of(context).colorScheme.primaryContainer,
              size: 20,
            ))
      ],
      pinned: true,
      expandedHeight: 50,
      toolbarHeight: 50,
      elevation: 1,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
