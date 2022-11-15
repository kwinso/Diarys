import 'package:diarys/theme/colors.dart';
import 'package:diarys/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsLogo extends ConsumerWidget {
  const SettingsLogo({
    Key? key,
  }) : super(key: key);

  final TextStyle mindallLogoTextStyle = const TextStyle(
    color: AppColors.red,
    fontWeight:FontWeight.bold ,
    shadows: [
      Shadow(
        offset: Offset(0, 0),
        blurRadius: 10.0,
        color: AppColors.red
      )
    ],
  );

  TextStyle getLogoStyle(int themeId) {
    if (themeId == 2) return mindallLogoTextStyle;
    return const TextStyle(fontWeight: FontWeight.w500);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themeId = ref.read(themeController).currentInt;
    print(themeId);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.center,
        child: RichText(
          text: TextSpan(
            text: 'by ',
            style: DefaultTextStyle.of(context).style.copyWith(
                color: Theme.of(context).colorScheme.tertiaryContainer),
            children: <TextSpan>[
              TextSpan(
                text: 'Little Kwinso.',
                style: getLogoStyle(themeId)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
