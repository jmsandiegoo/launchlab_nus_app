import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';

class SuccessFeedback extends StatelessWidget {
  const SuccessFeedback({
    super.key,
    required this.msg,
  });

  final String msg;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: successColor,
      ),
      padding: const EdgeInsets.all(10.0),
      // color: blackColor,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check,
              color: whiteColor,
            ),
            const SizedBox(
              width: 12.0,
            ),
            Text(
              msg,
              style: const TextStyle(color: whiteColor),
            ),
          ]),
    );
  }
}

class ErrorFeedback extends StatelessWidget {
  const ErrorFeedback({
    super.key,
    required this.msg,
  });

  final String msg;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: errorColor,
      ),
      padding: const EdgeInsets.all(5.0),
      child: Row(children: [
        const Icon(
          Icons.close_outlined,
          color: whiteColor,
        ),
        const SizedBox(
          width: 12.0,
        ),
        Text(
          msg,
          style: const TextStyle(
            color: whiteColor,
          ),
        ),
      ]),
    );
  }
}
