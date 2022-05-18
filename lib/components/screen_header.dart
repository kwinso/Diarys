import 'package:flutter/material.dart';

class ScreenHeaderButton {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? foreground;
  final Color? background;
  const ScreenHeaderButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.foreground,
    this.background,
  });
}

class ScreenHeader extends StatelessWidget {
  final String title;
  final List<ScreenHeaderButton> buttons;
  const ScreenHeader({Key? key, required this.title, required this.buttons}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Container(
        // Kind of adaptive padding to not to be too big on small screen
        padding: EdgeInsets.only(top: h * 0.06, bottom: h * 0.04),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.25, 0.6],
            colors: [Theme.of(context).primaryColor, Theme.of(context).backgroundColor],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                title,
                style: const TextStyle(fontSize: 30),
              ),
            ),
            AnimatedSize(
              duration: Duration(milliseconds: 200),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var b in buttons)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RawMaterialButton(
                          onPressed: b.onPressed,
                          elevation: 0,
                          fillColor: b.background ?? Theme.of(context).primaryColor,
                          child: Icon(
                            b.icon,
                            size: 25,
                            color: b.foreground ?? Theme.of(context).colorScheme.tertiary,
                          ),
                          padding: const EdgeInsets.all(10),
                          shape: const CircleBorder(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            b.label,
                            style: const TextStyle(fontSize: 12),
                          ),
                        )
                      ],
                    )
                ],
              ),
            )
          ],
        ));
  }
}
