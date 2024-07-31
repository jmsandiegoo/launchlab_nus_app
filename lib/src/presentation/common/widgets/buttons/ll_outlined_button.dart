import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/text/ll_body_text.dart';

class LLOutlinedButton extends StatelessWidget {
  const LLOutlinedButton(
      {super.key,
      required this.label,
      required this.onPressedHandler,
      required this.color,
      this.fontSize = 12,
      this.backgroundColor = Colors.transparent,
      this.backgroundActiveColor = blackColor,
      this.activeColor = whiteColor,
      this.isActive = false,
      this.isLoading = false});

  final String label;
  final void Function() onPressedHandler;
  final Color color;
  final double fontSize;
  final Color backgroundColor;
  final Color backgroundActiveColor;
  final Color activeColor;
  final bool isActive;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: () {
          if (isLoading) {
            return;
          }

          onPressedHandler();
        },
        style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: isActive ? activeColor : color,
              width: 0.5,
            ),
            backgroundColor:
                isActive ? backgroundActiveColor : backgroundColor),
        child: isLoading
            ? SizedBox(
                height: 17,
                width: 17,
                child: CircularProgressIndicator(strokeWidth: 1, color: isActive ? activeColor : color),
              )
            : LLBodyText(
                label: label,
                color: isActive ? activeColor : color,
                size: fontSize,
              ));
  }
}
