import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class SearchUserCard extends StatelessWidget {
  final UserEntity userData;
  const SearchUserCard({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            profilePicture(40, userData.userAvatar?.signedUrl ?? "",
                isUrl: true),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 3),
                    boldFirstText(
                        '${userData.firstName!} ${userData.lastName!}',
                        ' (@${userData.username})',
                        size: 13.5),
                    bodyText(userData.title!, size: 11.5),
                    bodyText(userData.userDegreeProgramme.toString(),
                        size: 11.5) //Need to init at backend
                  ]),
            ),
          ]),
          const SizedBox(height: 10),
          subHeaderText("Interest: ", size: 12.0),
          overflowText(userData.userPreference!.getSkillString(),
              size: 12.0, maxLines: 2),
        ]),
      ),
    );
  }
}
