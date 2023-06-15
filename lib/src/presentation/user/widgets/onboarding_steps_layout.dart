import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/user/cubits/onboarding_cubit.dart';
import 'package:launchlab/src/utils/helper.dart';

class OnboardingStepsLayout extends StatelessWidget {
  const OnboardingStepsLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: BlocConsumer<OnboardingCubit, OnboardingState>(
        listener: (context, state) {
          if (state.onboardingStatus == OnboardingStatus.nextPage) {
            navigatePush(context, "/onboard/step-${state.currStep}");
          }

          if (state.onboardingStatus == OnboardingStatus.prevPage) {
            state.currStep == 0
                ? navigateGo(context, "/onboard")
                : navigatePop(context);
          }
        },
        builder: (context, state) {
          OnboardingCubit onboardingStepsLayoutCubit =
              BlocProvider.of<OnboardingCubit>(context);
          return Scaffold(
            backgroundColor: lightGreyColor,
            appBar: AppBar(
              backgroundColor: lightGreyColor,
              leading: GestureDetector(
                onTap: () {
                  onboardingStepsLayoutCubit.handlePrevStep();
                },
                child: const Icon(Icons.keyboard_backspace_outlined),
              ),
              actions: onboardingStepsLayoutCubit.state.currStep >= 3
                  ? [
                      TextButton(
                          onPressed: () {
                            onboardingStepsLayoutCubit.handleNextStep();
                          },
                          child: const Text(
                            "Skip",
                            style: TextStyle(color: blackColor),
                          )),
                    ]
                  : [],
            ),
            body: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 20.0),
                child: child),
            bottomNavigationBar: BottomAppBar(
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
              color: lightGreyColor,
              elevation: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProgressIndicator(
                      steps: state.steps, currStep: state.currStep),
                  primaryButton(context, () {
                    print('pressed');
                    onboardingStepsLayoutCubit.handleNextStep();
                  }, state.currStep == state.steps ? "Finish" : "Next",
                      horizontalPadding: 40.0, elevation: 0),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

enum StepStates {
  complete,
  current,
  incomplete,
}

class ProgressIndicator extends StatelessWidget {
  const ProgressIndicator(
      {super.key, required this.steps, required this.currStep});

  final int steps;
  final int currStep;

  @override
  Widget build(BuildContext context) {
    List<Widget> stepWidgets = [];

    for (int i = 0; i < steps; i++) {
      if (i < currStep - 1) {
        stepWidgets.add(const ProgressStep(state: StepStates.complete));
      } else if (i == currStep - 1) {
        stepWidgets.add(const ProgressStep(state: StepStates.current));
      } else {
        stepWidgets.add(const ProgressStep(state: StepStates.incomplete));
      }
    }

    return Row(
      children: [
        ...stepWidgets,
      ],
    );
  }
}

class ProgressStep extends StatelessWidget {
  const ProgressStep({super.key, required this.state});

  final StepStates state;

  @override
  Widget build(BuildContext context) {
    String path = "assets/images/";
    if (state == StepStates.complete) {
      path += "step_complete.png";
    } else if (state == StepStates.current) {
      path += "step_current.png";
    } else {
      path += "step_incomplete.png";
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      height: state == StepStates.current ? 30.0 : 10.0,
      width: state == StepStates.current ? 30.0 : 10.0,
      child: Image.asset(
        path,
        fit: BoxFit.contain,
      ),
    );
  }
}
