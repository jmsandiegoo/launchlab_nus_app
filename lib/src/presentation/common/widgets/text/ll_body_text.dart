import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:launchlab/src/config/app_theme.dart';

class LLBodyText extends StatelessWidget {
  const LLBodyText({
    super.key,
    required this.label,
    this.size = 15.0,
    this.color = blackColor,
    this.maxLines,
    this.fontStyle = FontStyle.normal,
    this.fontWeight = FontWeight.w400,
    this.textAlign = TextAlign.left,
    this.textOverflow = TextOverflow.ellipsis,
  });

  final String label;
  final double size;
  final Color color;
  final int? maxLines;
  final FontStyle fontStyle;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final TextOverflow textOverflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: textOverflow,
      style: TextStyle(
        fontSize: size,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}
