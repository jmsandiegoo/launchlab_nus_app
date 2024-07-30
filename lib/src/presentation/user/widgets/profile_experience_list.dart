import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/text/ll_body_text.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/user/screens/profile_manage_experience_page.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';

class ProfileExperienceList extends StatelessWidget {
  const ProfileExperienceList({
    super.key,
    this.isAuthProfile = false,
    required this.experiences,
    required this.onUpdateHandler,
  });
  final bool isAuthProfile;
  final List<ExperienceEntity> experiences;
  final void Function() onUpdateHandler;

  Future<void> manageExperience(
      BuildContext context, ProfileManageExperiencePageProps props) async {
    final NavigationData<Object?>? returnData =
        await navigatePushWithData<Object?>(
      context,
      "/profile/manage-experience",
      props,
    );

    if (returnData == null || returnData.actionType == ActionTypes.cancel) {
      return;
    }

    if (returnData.actionType == ActionTypes.update) {
      onUpdateHandler();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isAuthProfile && experiences.isEmpty) {
      return const SizedBox(
        height: 0,
        width: 0,
      );
    }

    List<ExperienceEntity> sortedExperiences = [...experiences];

    sortedExperiences.sort((exp1, exp2) {
      if (exp1 == exp2) {
        return 0;
      }

      if (exp1.isCurrent && !exp2.isCurrent) {
        return -1;
      } else if (!exp1.isCurrent && exp2.isCurrent) {
        return 1;
      } else if (exp1.isCurrent && exp2.isCurrent) {
        return exp1.startDate.compareTo(exp2.startDate);
      } else {
        return exp1.endDate!.compareTo(exp2.endDate!);
      }
    });

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            subHeaderText("Experience"),
            ...() {
              if (!isAuthProfile) {
                return [
                  const SizedBox(height: 45.0),
                ];
              }
              return [
                IconButton(
                  onPressed: () {
                    manageExperience(
                      context,
                      ProfileManageExperiencePageProps(
                          userExperiences: experiences),
                    );
                  },
                  icon: const Icon(Icons.edit_outlined, color: blackColor),
                ),
              ];
            }(),
          ],
        ),
        const SizedBox(height: 5),
        IntrinsicHeight(
          child: Row(
            children: <Widget>[
              Container(
                width: 1,
                height: double.infinity,
                color: blackColor,
                margin: const EdgeInsets.only(top: 10, right: 15),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...() {
                      if (sortedExperiences.isEmpty) {
                        return [const LLBodyText(label: "No experiences stated.")];
                      }
                      return sortedExperiences
                          .map((item) => ExperienceWidget(experience: item))
                          .toList();
                    }(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ExperienceWidget extends StatelessWidget {
  const ExperienceWidget({super.key, required this.experience});

  final ExperienceEntity experience;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  smallText(
                      "${dateStringFormatter("dd MMM yyyy", experience.startDate)} - ${experience.endDate != null ? dateStringFormatter("dd MMM yyyy", experience.endDate!) : "Present"}",
                      color: greyColor.shade700),
                  const SizedBox(height: 1.0),
                  smallText(experience.title, weight: FontWeight.w600),
                  const SizedBox(height: 1.0),
                ],
              ),
            ],
          ),
          smallText(experience.companyName),
          const SizedBox(height: 5.0),
          smallText(experience.description),
        ],
      ),
    );
  }
}
