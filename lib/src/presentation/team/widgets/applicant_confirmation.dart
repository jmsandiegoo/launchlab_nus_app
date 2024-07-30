import 'package:flutter/material.dart';
import 'package:launchlab/src/presentation/common/widgets/text/ll_body_text.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class ApplicationConfirmationBox extends StatelessWidget {
  final VoidCallback onClose;
  final String title;
  final String message;

  const ApplicationConfirmationBox({
    super.key,
    required this.title,
    required this.message,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: LLBodyText(label: message),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            style: TextButton.styleFrom(textStyle: const TextStyle()),
            child:
                const LLBodyText(label: "Yes", fontWeight: FontWeight.bold, color: Colors.blue)),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            style: TextButton.styleFrom(textStyle: const TextStyle()),
            child: const LLBodyText(label: 'No', fontWeight: FontWeight.bold, color: Colors.blue)),
      ],
    );
  }
}
