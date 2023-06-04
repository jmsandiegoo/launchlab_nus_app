import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/utils/helper.dart';

class OnboardingWelcomePage extends StatelessWidget {
  const OnboardingWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 290,
              height: 190,
              child: Image.asset("assets/images/onboard_welcome.png"),
            ),
            const SizedBox(
              height: 25.0,
            ),
            headerText("Welcome to \n Launchlab NUS",
                alignment: TextAlign.center),
            const SizedBox(
              height: 10.0,
            ),
            bodyText("Let us first help you \n get onboarded!",
                alignment: TextAlign.center),
            const SizedBox(
              height: 25.0,
            ),
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 170.0),
                width: double.infinity,
                child: secondaryButton(
                    context,
                    () => navigateGo(context, "/onboard/step-1"),
                    "Get Started"),
                // child: ElevatedButton(
                //   style: ButtonStyle(
                //       backgroundColor: MaterialStateProperty.all<Color>(
                //           Theme.of(context).colorScheme.secondary)),
                //   onPressed: () => navigateGo(context, "/onboard/step-1"),
                //   child: const Text("Get Started"),
                // ),
              ),
            ),
            const SizedBox(
              height: 25.0,
            ),
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 200.0),
                width: double.infinity,
                child: TextButton(
                    onPressed: () => print("Test"),
                    child: const Text(
                      "Sign Out",
                      style: TextStyle(color: blackColor),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}