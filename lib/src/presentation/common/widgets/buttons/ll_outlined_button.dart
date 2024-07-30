import 'package:flutter/material.dart';
import 'package:launchlab/src/presentation/common/widgets/text/ll_body_text.dart';

class LLOutlinedButton extends StatelessWidget {
  const LLOutlinedButton(
      {super.key,
      required this.label,
      required this.onPressedHandler,
      required this.color,
      this.backgroundActiveColor = Colors.transparent,
      this.isActive = false,
      this.isLoading = false});

  final String label;
  final void Function() onPressedHandler;
  final Color color;
  final Color backgroundActiveColor;
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
        style: OutlinedButton.styleFrom(side: BorderSide(color: color, width: 0.5, )),
        child: isLoading
            ? SizedBox(
                height: 17,
                width: 17,
                child: CircularProgressIndicator(strokeWidth: 1, color: color),
              )
            : LLBodyText(label: label, color: color));
          
  }
}