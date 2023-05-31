import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/presentation/common/cubits/app_root_cubit.dart';
import 'package:launchlab/src/presentation/user/cubits/onboarding_container_cubit.dart';

class OnboardingContainer extends StatelessWidget {
  const OnboardingContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => OnboardingContainerCubit(),
        child: BlocConsumer<AppRootCubit, AppRootState>(
          builder: (context, state) => child,
          listener: (context, state) => print("watch onboard state"),
        ));
  }
}
