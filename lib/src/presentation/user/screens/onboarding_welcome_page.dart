import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/cubits/app_root_cubit.dart';
import 'package:launchlab/src/presentation/common/widgets/feedback_toast.dart';
import 'package:launchlab/src/presentation/common/widgets/text/ll_body_text.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/user/cubits/onboarding_cubit.dart';
import 'package:launchlab/src/utils/helper.dart';
import 'package:launchlab/src/utils/toast_manager.dart';

class OnboardingWelcomePage extends StatelessWidget {
  const OnboardingWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    AppRootCubit appRootCubit = BlocProvider.of<AppRootCubit>(context);
    OnboardingCubit onboardingCubit = BlocProvider.of<OnboardingCubit>(context);

    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state.onboardingStatus == OnboardingStatus.nextPage) {
          navigateGo(context, "/onboard/step-${state.currStep}");
        }

        if (state.onboardingStatus == OnboardingStatus.initializingError &&
            state.error != null) {
          ToastManager()
              .showFToast(child: ErrorFeedback(msg: state.error!.errorMessage));
        }
      },
      builder: (context, state) => Scaffold(
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
              const LLBodyText(label: "Let us first help you \n get onboarded!",
                  textAlign: TextAlign.center),
              const SizedBox(
                height: 25.0,
              ),
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 170.0),
                  width: double.infinity,
                  child: secondaryButton(context, () {
                    onboardingCubit.handleInitializeForm();
                  }, "Get Started",
                      isLoading: state.onboardingStatus ==
                          OnboardingStatus.initializing),
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
                      onPressed: () => appRootCubit.handleSignOut(),
                      child: const Text(
                        "Sign Out",
                        style: TextStyle(color: blackColor),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
