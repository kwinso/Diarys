import 'package:flutter/material.dart';

class MultilineHint extends StatelessWidget {
  const MultilineHint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.info_outlined,
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                )),
            Flexible(
                child: Text(
              "Перечесляйте предметы с новой строки, чтобы добавить сразу несколько",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiaryContainer),
            ))
          ],
        ));
  }
}
