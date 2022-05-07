import 'package:diarys/screens/settings.dart';
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
      child: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Stack(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
          ),
          Center(
              child: Text(
            "Diarys",
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.primaryContainer,
              fontFamily: "RubikMonoOne",
            ),
          ))
        ]),
      ),
      // child: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 20),
      //     child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         children: [
      //           Row(
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               LogoText(
      //                 "D",
      //                 Theme.of(context).colorScheme.secondary,
      //               ),
      //               LogoText("IAR", Theme.of(context).colorScheme.tertiary),
      //               LogoText(
      //                 "Y",
      //                 Theme.of(context).colorScheme.secondary,
      //               ),
      //               LogoText("S", Theme.of(context).colorScheme.tertiary),
      //             ],
      //           ),
      //         ])),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
