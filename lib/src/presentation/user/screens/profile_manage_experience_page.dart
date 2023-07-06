import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/feedback_toast.dart';
import 'package:launchlab/src/presentation/user/cubits/profile_manage_experience_page_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/experience_list.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';
import 'package:launchlab/src/utils/toast_manager.dart';

class ProfileManageExperiencePageProps {
  const ProfileManageExperiencePageProps({
    required this.userExperiences,
  });

  final List<ExperienceEntity> userExperiences;
}

class ProfileManageExperiencePage extends StatelessWidget {
  const ProfileManageExperiencePage({super.key, required this.props});

  final ProfileManageExperiencePageProps props;

  Future<void> handleAddExperience(
    BuildContext context,
    void Function(List<ExperienceEntity> val) onChangedHandler,
    List<ExperienceEntity> experiences,
  ) async {
    final returnData = await navigatePush(
      context,
      "/profile/manage-experience/add-experience",
    );

    if (returnData == null || returnData.actionType == ActionTypes.cancel) {
      return;
    }

    if (returnData.actionType == ActionTypes.create) {
      final newExperiences = [...experiences];
      newExperiences.add(returnData.data);
      onChangedHandler(newExperiences);
      ToastManager().showFToast(
          child: const SuccessFeedback(
        msg: "Create experience successful!",
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileManageExperiencePageCubit(
        userExperiences: props.userExperiences,
      ),
      child: BlocConsumer<ProfileManageExperiencePageCubit,
          ProfileManageExperiencePageState>(
        listener: (context, state) {},
        builder: (context, state) {
          final profileManageExperiencePageCubit =
              BlocProvider.of<ProfileManageExperiencePageCubit>(context);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: lightGreyColor,
              leading: GestureDetector(
                onTap: () {
                  if (state.profileExperienceListPageStatus ==
                      ProfileExperienceListPageStatus.success) {
                    navigatePopWithData(context, null, ActionTypes.update);
                    return;
                  }
                  navigatePop(context);
                },
                child: const Icon(Icons.keyboard_backspace_outlined),
              ),
              title: const Text("Experiences"),
              actions: [
                GestureDetector(
                  onTap: () {
                    handleAddExperience(
                        context,
                        profileManageExperiencePageCubit
                            .onExperienceListChanged,
                        state.userExperiences.value);
                  },
                  child: const Icon(Icons.add_outlined),
                ),
              ],
            ),
            body: ExperienceList(
              isOnboardMode: false,
              experiences: state.userExperiences.value,
              onAddHandler: () async => handleAddExperience(
                  context,
                  profileManageExperiencePageCubit.onExperienceListChanged,
                  state.userExperiences.value),
              onEditHandler: (exp) async {
                final NavigationData<ExperienceEntity>? returnData =
                    await navigatePushWithData<ExperienceEntity>(context,
                        "/profile/manage-experience/edit-experience", exp);

                List<ExperienceEntity> newExperiences = [
                  ...state.userExperiences.value
                ];
                final index = newExperiences.indexOf(exp);

                if (returnData == null ||
                    returnData.actionType == ActionTypes.cancel) {
                  return;
                }

                if (returnData.actionType == ActionTypes.update) {
                  newExperiences[index] = returnData.data!;
                  profileManageExperiencePageCubit
                      .onExperienceListChanged(newExperiences);
                  ToastManager().showFToast(
                      child: const SuccessFeedback(
                    msg: "Edit experience successful!",
                  ));
                }

                if (returnData.actionType == ActionTypes.delete) {
                  newExperiences.removeAt(index);
                  profileManageExperiencePageCubit
                      .onExperienceListChanged(newExperiences);
                  ToastManager().showFToast(
                      child: const SuccessFeedback(
                    msg: "Delete experience successful!",
                  ));
                }
              },
            ),
          );
        },
      ),
    );
  }
}
