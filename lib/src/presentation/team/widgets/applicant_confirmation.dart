import 'package:flutter/material.dart';
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
      content: bodyText(message),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            style: TextButton.styleFrom(textStyle: const TextStyle()),
            child:
                bodyText('Yes', weight: FontWeight.bold, color: Colors.blue)),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            style: TextButton.styleFrom(textStyle: const TextStyle()),
            child: bodyText('No', weight: FontWeight.bold, color: Colors.blue)),
      ],
    );
  }
}
