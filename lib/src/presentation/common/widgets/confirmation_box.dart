import 'package:flutter/material.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class ConfirmationBox extends StatelessWidget {
  final VoidCallback onClose;
  final String title;
  final String message;

  const ConfirmationBox({
    super.key,
    required this.title,
    required this.message,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: bodyText(message),
      actions: [
        ElevatedButton(onPressed: onClose, child: bodyText("  Ok  ")),
      ],
    );
  }
}
