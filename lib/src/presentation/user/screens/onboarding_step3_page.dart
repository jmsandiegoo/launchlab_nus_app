import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/file_upload.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/user/cubits/onboarding_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/experience_list.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';

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
          onAddHandler: () async {
            final returnData = await navigatePush(
              context,
              "/profile/manage-experience/add-experience",
            );

            if (returnData == null ||
                returnData.actionType == ActionTypes.cancel) {
              return;
            }

            if (returnData.actionType == ActionTypes.create) {
              final newExperiences = [
                ..._onboardingCubit.state.experienceListInput.value
              ];
              newExperiences.add(returnData.data);
              _onboardingCubit.onExperienceListChanged(
                newExperiences,
              );
            }
          },
          onEditHandler: (exp) async {
            final NavigationData<ExperienceEntity>? returnData =
                await navigatePushWithData<ExperienceEntity>(
                    context, "/onboard-edit-experience", exp);

            List<ExperienceEntity> newExperiences = [
              ..._onboardingCubit.state.experienceListInput.value
            ];

            final index = newExperiences.indexOf(exp);

            if (returnData == null ||
                returnData.actionType == ActionTypes.cancel) {
              return;
            }

            if (returnData.actionType == ActionTypes.update) {
              newExperiences[index] = returnData.data!;
              _onboardingCubit.onExperienceListChanged(newExperiences);
            }

            if (returnData.actionType == ActionTypes.delete) {
              newExperiences.removeAt(index);
              _onboardingCubit.onExperienceListChanged(newExperiences);
            }
          },
        ),
      ],
    );
  }
}
