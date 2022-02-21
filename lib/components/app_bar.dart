import 'package:diarys/theme/themes.dart';
import 'package:flutter/material.dart';

class LogoText extends StatelessWidget {
  final String data;
  final Color color;

  const LogoText(this.data, this.color, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(minHeight: 25),
        height: 25,
        child: Text(data,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, color: color, fontFamily: "RubikMonoOne")));
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height = 50;

  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LogoText(
                        "D",
                        Theme.of(context).colorScheme.secondary,
                      ),
                      LogoText("IAR", Theme.of(context).colorScheme.tertiary),
                      LogoText(
                        "Y",
                        Theme.of(context).colorScheme.secondary,
                      ),
                      LogoText("S", Theme.of(context).colorScheme.tertiary),
                    ],
                  ),
                  IconButton(
                      tooltip: "Настройки",
                      splashRadius: 1,
                      onPressed: () => currentTheme.toggle(),
                      icon: Icon(
                        Icons.settings,
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                        size: 30,
                      ))
                ])));
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
