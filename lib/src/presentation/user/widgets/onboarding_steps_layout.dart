import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/user/cubits/onboarding_steps_layout_cubit.dart';

class OnboardingStepsLayout extends StatelessWidget {
  const OnboardingStepsLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingStepsLayoutCubit(),
      child:
          BlocBuilder<OnboardingStepsLayoutCubit, OnboardingStepsLayoutState>(
        builder: (context, state) {
          OnboardingStepsLayoutCubit onboardingStepsLayoutCubit =
              BlocProvider.of<OnboardingStepsLayoutCubit>(context);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: lightGreyColor,
              leading: GestureDetector(
                onTap: () {
                  onboardingStepsLayoutCubit.handlePrevStep();
                  state.currStep == 1
                      ? navigateGo(context, "/onboard")
                      : navigatePop(context);
                },
                child: const Icon(Icons.keyboard_backspace_outlined),
              ),
            ),
            body: child,
            bottomNavigationBar: BottomAppBar(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              color: lightGreyColor,
              elevation: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProgressIndicator(
                      steps: state.steps, currStep: state.currStep),
                  primaryButton(context, () {
                    navigatePush(
                        context, "/onboard/step-${state.currStep + 1}");
                    onboardingStepsLayoutCubit.handleNextStep();
                  }, state.currStep == state.steps ? "Finish" : "Next",
                      horizontalPadding: 50.0),
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
