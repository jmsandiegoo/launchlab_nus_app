import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/user/cubits/onboarding_cubit.dart';
import 'package:launchlab/src/presentation/user/screens/accomplishment_list.dart';

class OnboardingStep4Page extends StatelessWidget {
  const OnboardingStep4Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      // ignore: prefer_const_constructors
      builder: (context, state) => OnboardingStep4Content(),
    );
  }
}

class OnboardingStep4Content extends StatefulWidget {
  const OnboardingStep4Content({super.key});

  @override
  State<OnboardingStep4Content> createState() => _OnboardingStep4ContentState();
}

class _OnboardingStep4ContentState extends State<OnboardingStep4Content> {
  late OnboardingCubit _onboardingCubit;

  @override
  void initState() {
    super.initState();
    _onboardingCubit = BlocProvider.of<OnboardingCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        headerText("Share your accomplishments"),
        bodyText(
            "Also, feel free to share some accomplishments you have made such as CCAs, awards etc."),
        const SizedBox(
          height: 20.0,
        ),
        AccomplishmentList(
          accomplishments: _onboardingCubit.state.accomplishmentListInput.value,
          onChangedHandler: (values) =>
              _onboardingCubit.onAccomplishmentListChanged(values),
        )
      ],
    );
  }
}
