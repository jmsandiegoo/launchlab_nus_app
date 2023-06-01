import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class OnboardingStep1Page extends StatelessWidget {
  const OnboardingStep1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        headerText("Tell us about yourself"),
      ],
    );
  }
}
