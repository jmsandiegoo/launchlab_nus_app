import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/file_upload.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/user/cubits/onboarding_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/experience_list.dart';

class OnboardingStep3Page extends StatelessWidget {
  const OnboardingStep3Page({super.key});

  @override
  Widget build(BuildContext context) {
    print('rebuild parent');
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      // ignore: prefer_const_constructors
      builder: (context, state) => OnboardingStep3Content(),
    );
  }
}

class OnboardingStep3Content extends StatefulWidget {
  const OnboardingStep3Content({super.key});

  @override
  State<OnboardingStep3Content> createState() => _OnboardingStep3ContentState();
}

class _OnboardingStep3ContentState extends State<OnboardingStep3Content> {
  late OnboardingCubit _onboardingCubit;

  @override
  void initState() {
    super.initState();
    _onboardingCubit = BlocProvider.of<OnboardingCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild');
    return ListView(
      children: [
        headerText("Upload Resume"),
        const SizedBox(
          height: 20.0,
        ),
        FileUploadWidget(
          selectedFile: _onboardingCubit.state.userResumeInput.value,
          onFileUploadChangedHandler: (value) =>
              _onboardingCubit.onUserResumeChanged(value),
        ),
        const SizedBox(
          height: 20.0,
        ),
        headerText("Share your experience"),
        bodyText(
            "You can choose to share some work experiences you have for other users to see."),
        const SizedBox(
          height: 20.0,
        ),
        ExperienceList(
          experiences: _onboardingCubit.state.experienceListInput.value,
          onChangedHandler: (values) =>
              _onboardingCubit.onExperienceListChanged(values),
        ),
      ],
    );
  }
}
