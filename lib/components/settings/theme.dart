import 'package:diarys/theme/colors.dart';
import 'package:diarys/theme/theme_controller.dart';
import 'package:diarys/theme/themes/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeSelectSection extends StatelessWidget {
  const ThemeSelectSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Тема",
          style: TextStyle(fontSize: 25),
        ),
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0, 0.025, 0.975, 1],
              colors: <Color>[Colors.black, Colors.transparent, Colors.transparent, Colors.black],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstOut,
          child: Container(
            margin: EdgeInsets.only(top: 10),
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (var i = 0; i < AppThemeController.themes.length; i++)
                  ThemeSelectTile(themeIndex: i),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class ThemeSelectTile extends ConsumerWidget {
  final int themeIndex;
  const ThemeSelectTile({Key? key, required this.themeIndex}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppThemeController.themes[themeIndex];
    final currentTheme = ref.watch(themeController);
    return GestureDetector(
      onTap: () => ref.read(themeController).setTheme(themeIndex),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
              height: 140,
              margin: EdgeInsets.only(bottom: 10),
              width: 100,
              decoration: BoxDecoration(
                border: Border.all(
                  color: currentTheme.currentInt == themeIndex
                      ? AppColors.secondary
                      : Theme.of(context).colorScheme.tertiary,
                ),
                color: theme.data.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: _AbstractThemeLayout(theme.data),
            ),
            Text(
              theme.name,
              style:
                  TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.tertiaryContainer),
            )
          ],
        ),
      ),
    );
  }
}

class _AbstractThemeLayout extends StatelessWidget {
  final ThemeData theme;
  const _AbstractThemeLayout(this.theme, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // parent width
    return LayoutBuilder(
      builder: (context, constraints) {
        // Parent width and height
        final pw = constraints.minWidth;
        final ph = constraints.minHeight;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: _AbstractLayoutLine(
                margin: EdgeInsets.only(top: ph * 0.2),
                color: theme.colorScheme.tertiary,
                width: pw * 0.4,
                height: 4,
              ),
            ),
            _AbstractLayoutLine(
              margin: EdgeInsets.only(left: pw * 0.05, bottom: 3, top: ph * 0.1),
              color: theme.colorScheme.tertiaryContainer,
              width: pw * 0.15,
              height: 4,
            ),
            _AbstractTaskTile(
              theme,
              parentHeight: ph,
              parentWidth: pw,
            ),
            _AbstractTaskTile(
              theme,
              parentHeight: ph,
              parentWidth: pw,
            ),
          ],
        );
      },
    );
  }
}

class _AbstractTaskTile extends StatelessWidget {
  final ThemeData theme;
  final double parentHeight;
  final double parentWidth;
  const _AbstractTaskTile(
    this.theme, {
    Key? key,
    required this.parentHeight,
    required this.parentWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 2),
          padding: EdgeInsets.symmetric(horizontal: 3),
          height: parentHeight * 0.1,
          width: parentWidth * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: theme.primaryColor,
          ),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 3),
                height: parentHeight * 0.05,
                width: parentHeight * 0.05,
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.yellow),
              ),
              _AbstractLayoutLine(
                  width: parentWidth * 0.2, height: 4, color: theme.colorScheme.tertiary)
            ],
          )),
    );
  }
}

class _AbstractLayoutLine extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final EdgeInsets? margin;
  const _AbstractLayoutLine({
    Key? key,
    required this.width,
    required this.height,
    this.margin,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      // boxDe
    );
  }
}
