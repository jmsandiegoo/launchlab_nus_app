import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/user/models/preference_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/user/screens/profile_edit_skills_page.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';

class ProfileSkills extends StatelessWidget {
  const ProfileSkills({
    super.key,
    required this.userPreference,
    required this.onUpdateHandler,
  });

  final PreferenceEntity userPreference;
  final void Function() onUpdateHandler;

  Future<void> editProfileSkills(
      BuildContext context, ProfileEditSkillsPageProps props) async {
    final NavigationData<Object?>? returnData =
        await navigatePushWithData<Object?>(
            context, "/profile/edit-skills", props);

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
            subHeaderText("Skills"),
            IconButton(
              onPressed: () {
                editProfileSkills(
                    context,
                    ProfileEditSkillsPageProps(
                      userPreference: userPreference,
                    ));
              },
              icon: const Icon(Icons.edit_outlined, color: blackColor),
            ),
          ],
        ),
        const SizedBox(height: 5),
        chipsWrap(userPreference.skillsInterests),
      ],
    );
  }
}
