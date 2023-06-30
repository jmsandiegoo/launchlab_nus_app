import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/user/screens/profile_edit_about_page.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';

class ProfileAbout extends StatelessWidget {
  const ProfileAbout({
    super.key,
    this.isAuthProfile = false,
    required this.userProfile,
    required this.onUpdateHandler,
  });

  final bool isAuthProfile;
  final UserEntity userProfile;
  final void Function() onUpdateHandler;

  Future<void> editProfileAbout(
      BuildContext context, ProfileEditAboutPageProps props) async {
    final NavigationData<Object?>? returnData =
        await navigatePushWithData<Object?>(
            context, "/profile/${userProfile.id}/edit-about", props);

    if (returnData == null) {
      return;
    }

    if (returnData.actionType == ActionTypes.update) {
      onUpdateHandler();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            subHeaderText("About me"),
            ...() {
              if (!isAuthProfile) {
                return [
                  const SizedBox(height: 45.0),
                ];
              }

              return [
                IconButton(
                  onPressed: () {
                    editProfileAbout(context,
                        ProfileEditAboutPageProps(userProfile: userProfile));
                  },
                  icon: const Icon(Icons.edit_outlined, color: blackColor),
                ),
              ];
            }(),
          ],
        ),
        bodyText(userProfile.about!),
      ],
    );
  }
}
