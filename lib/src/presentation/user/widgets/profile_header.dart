import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';
import 'package:launchlab/src/domain/user/models/user_avatar_entity.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/user/screens/profile_edit_intro_page.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    this.isAuthProfile = false,
    required this.userProfile,
    required this.userDegreeProgramme,
    this.userAvatar,
    required this.onUpdateHandler,
  });

  final bool isAuthProfile;
  final UserEntity userProfile;
  final DegreeProgrammeEntity userDegreeProgramme;
  final UserAvatarEntity? userAvatar;
  final void Function() onUpdateHandler;

  Future<void> editProfileIntro(
      BuildContext context, ProfileEditIntroPageProps props) async {
    final NavigationData<Object?>? returnData =
        await navigatePushWithData<Object?>(
            context, "/profile/${userProfile.id}/edit-intro", props);

    if (returnData == null) {
      return;
    }

    if (returnData.actionType == ActionTypes.update) {
      onUpdateHandler();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      decoration: const BoxDecoration(
          color: yellowColor,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(40),
            bottomLeft: Radius.circular(40),
          )),
      child: Column(
        children: [
          Stack(
            children: [
              ...() {
                if (!isAuthProfile) {
                  return [];
                }

                return [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: const EdgeInsets.only(right: 15.0),
                      child: IconButton(
                        onPressed: () {
                          editProfileIntro(
                              context,
                              ProfileEditIntroPageProps(
                                userProfile: userProfile,
                                userDegreeProgramme: userDegreeProgramme,
                                userAvatar: userAvatar,
                              ));
                        },
                        icon:
                            const Icon(Icons.edit_outlined, color: blackColor),
                      ),
                    ),
                  ),
                ];
              }(),
              Center(
                  child: profilePicture(
                      100, userAvatar?.signedUrl ?? "avatar_temp.png",
                      isUrl: userAvatar?.signedUrl != null ? true : false)),
            ],
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 300,
            ),
            child: Column(
              children: [
                const SizedBox(height: 15),
                headerText("${userProfile.firstName} ${userProfile.lastName}",
                    alignment: TextAlign.center),
                smallText("@ ${userProfile.username}"),
                const SizedBox(height: 5),
                bodyText(userProfile.title!, alignment: TextAlign.center),
                bodyText(userDegreeProgramme.name,
                    color: darkGreyColor, alignment: TextAlign.center),
                const SizedBox(height: 35),
              ],
            ),
          ),
          const TeamStatsBar(
            teamStats: [
              TeamStat(
                  textLabel: "Completed",
                  numVal: 5,
                  icon: Icons.check_circle_sharp),
              TeamStat(
                textLabel: "Leading",
                numVal: 4,
                icon: Icons.people_alt,
              ),
              TeamStat(
                textLabel: "Participating",
                numVal: 4,
                icon: Icons.handshake_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TeamStat extends Equatable {
  const TeamStat({
    required this.textLabel,
    required this.numVal,
    required this.icon,
  });
  final String textLabel;
  final int numVal;
  final IconData icon;

  @override
  List<Object?> get props => [
        textLabel,
        numVal,
        icon,
      ];
}

class TeamStatsBar extends StatelessWidget {
  const TeamStatsBar({super.key, this.teamStats = const []});

  final List<TeamStat> teamStats;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...() {
          return teamStats.map((item) => TeamStatsBox(teamStat: item)).toList();
        }(),
      ],
    );
  }
}

class TeamStatsBox extends StatelessWidget {
  const TeamStatsBox({
    super.key,
    required this.teamStat,
  });

  final TeamStat teamStat;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      height: 50,
      width: 90,
      decoration: const BoxDecoration(
          color: blackColor,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            teamStat.textLabel,
            style: const TextStyle(fontSize: 12.0, color: yellowColor),
          ),
          const SizedBox(height: 3),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(teamStat.icon, color: yellowColor, size: 12.0),
            const SizedBox(width: 2),
            Text(
              teamStat.numVal.toString(),
              style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: yellowColor),
            )
          ])
        ],
      ),
    );
  }
}
