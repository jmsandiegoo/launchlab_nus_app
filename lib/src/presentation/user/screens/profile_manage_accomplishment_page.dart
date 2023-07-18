import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/feedback_toast.dart';
import 'package:launchlab/src/presentation/user/cubits/profie_manage_accomplishment_page_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/accomplishment_list.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';
import 'package:launchlab/src/utils/toast_manager.dart';

class ProfileManageAccomplishmentPageProps {
  const ProfileManageAccomplishmentPageProps({
    required this.userAccomplishments,
  });

  final List<AccomplishmentEntity> userAccomplishments;
}

class ProfileManageAccomplishmentPage extends StatelessWidget {
  const ProfileManageAccomplishmentPage({super.key, required this.props});

  final ProfileManageAccomplishmentPageProps props;

  Future<void> handleAddAccomplishment(
    BuildContext context,
    void Function(List<AccomplishmentEntity> val) onChangedHandler,
    List<AccomplishmentEntity> accomplishments,
  ) async {
    final returnData = await navigatePush(
      context,
      "/profile/manage-accomplishment/add-accomplishment",
    );

    if (returnData == null || returnData.actionType == ActionTypes.cancel) {
      return;
    }

    if (returnData.actionType == ActionTypes.create) {
      final newAccomplishments = [...accomplishments];
      newAccomplishments.add(returnData.data);
      onChangedHandler(newAccomplishments);
      ToastManager().showFToast(
          child: const SuccessFeedback(
        msg: "Create accomplishment successful!",
      ));
      // show success message
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileManageAccomplishmentPageCubit(
        userAccomplishments: props.userAccomplishments,
      ),
      child: BlocConsumer<ProfileManageAccomplishmentPageCubit,
          ProfileManageAccomplishmentPageState>(
        listener: (context, state) {},
        builder: (context, state) {
          final profileManageAccomplishmentPageCubit =
              BlocProvider.of<ProfileManageAccomplishmentPageCubit>(context);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: lightGreyColor,
              leading: GestureDetector(
                onTap: () {
                  if (state.profileManageAccomplishmentPageStatus ==
                      ProfileManageAccomplishmentPageStatus.success) {
                    navigatePopWithData(context, null, ActionTypes.update);
                    return;
                  }
                  navigatePop(context);
                },
                child: const Icon(Icons.keyboard_backspace_outlined),
              ),
              title: const Text("Accomplishments"),
              actions: [
                GestureDetector(
                  onTap: () {
                    handleAddAccomplishment(
                        context,
                        profileManageAccomplishmentPageCubit
                            .onAccomplishmentListChanged,
                        state.userAccomplishments.value);
                  },
                  child: const Icon(Icons.add_outlined),
                ),
              ],
            ),
            body: AccomplishmentList(
              isOnboardMode: false,
              accomplishments: state.userAccomplishments.value,
              onAddHandler: () async => handleAddAccomplishment(
                  context,
                  profileManageAccomplishmentPageCubit
                      .onAccomplishmentListChanged,
                  state.userAccomplishments.value),
              onEditHandler: (acc) async {
                final NavigationData<AccomplishmentEntity>? returnData =
                    await navigatePushWithData<AccomplishmentEntity>(
                        context,
                        "/profile/manage-accomplishment/edit-accomplishment",
                        acc);

                List<AccomplishmentEntity> newAccomplishments = [
                  ...state.userAccomplishments.value
                ];
                final index = newAccomplishments.indexOf(acc);

                if (returnData == null ||
                    returnData.actionType == ActionTypes.cancel) {
                  return;
                }

                if (returnData.actionType == ActionTypes.update) {
                  newAccomplishments[index] = returnData.data!;
                  profileManageAccomplishmentPageCubit
                      .onAccomplishmentListChanged(newAccomplishments);
                  ToastManager().showFToast(
                      child: const SuccessFeedback(
                    msg: "Edit accomplishment successful!",
                  ));
                }

                if (returnData.actionType == ActionTypes.delete) {
                  newAccomplishments.removeAt(index);
                  profileManageAccomplishmentPageCubit
                      .onAccomplishmentListChanged(newAccomplishments);
                  ToastManager().showFToast(
                      child: const SuccessFeedback(
                    msg: "Delete accomplishment successful!",
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
