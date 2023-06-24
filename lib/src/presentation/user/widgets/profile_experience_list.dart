import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/utils/helper.dart';

class ProfileExperienceList extends StatelessWidget {
  const ProfileExperienceList({
    super.key,
    required this.experiences,
  });

  final List<ExperienceEntity> experiences;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            subHeaderText("Experience"),
            IconButton(
              onPressed: () {
                navigatePush(context, "/profile/manage-experience");
              },
              icon: const Icon(Icons.edit_outlined, color: blackColor),
            ),
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
                      if (experiences.isEmpty) {
                        return [bodyText("You have no experiences stated.")];
                      }
                      return experiences
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
                      "${dateStringFormatter("dd MMM yyyy", experience.startDate)} - ${experience.endDate != null ? dateStringFormatter("MMM yyyy", experience.endDate!) : "Present"}",
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
