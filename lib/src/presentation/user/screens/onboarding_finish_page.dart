import 'package:flutter/material.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class OnboardingFinishPage extends StatelessWidget {
  const OnboardingFinishPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          Image.asset("assets/images/onboard_finish.png"),
          headerText("Congrats your are now ready to use the application!"),
          ElevatedButton(
            onPressed: () => print("pressed"),
            child: const Text("Okay"),
          ),
        ]),
      ),
    );
  }
}
