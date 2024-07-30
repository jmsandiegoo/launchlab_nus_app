import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/text/ll_body_text.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/utils/helper.dart';

class ExperienceList extends StatelessWidget {
  const ExperienceList({
    super.key,
    required this.experiences,
    required this.onAddHandler,
    required this.onEditHandler,
    this.isOnboardMode = true,
  });

  final List<ExperienceEntity> experiences;
  final Future<void> Function() onAddHandler;
  final Future<void> Function(ExperienceEntity) onEditHandler;
  final bool isOnboardMode;

  @override
  Widget build(BuildContext context) {
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...() {
          return sortedExperiences
              .map((item) => ExperienceCard(
                  experience: item, onTapHandler: (exp) => onEditHandler(exp)))
              .toList();
        }(),
        ...() {
          if (isOnboardMode) {
            return [
              LimitedBox(
                maxWidth: 100,
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: blackColor,
                    ),
                    onPressed: () {
                      onAddHandler();
                    },
                    child: const LLBodyText(label: "Add", color: whiteColor)),
              )
            ];
          }
          return [];
        }(),
      ],
    );
  }
}

class ExperienceCard extends StatelessWidget {
  const ExperienceCard(
      {super.key, required this.experience, required this.onTapHandler});

  final ExperienceEntity experience;
  final void Function(ExperienceEntity) onTapHandler;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
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
                        "${dateStringFormatter("dd MMM yyyy", experience.startDate)} - ${experience.endDate != null ? dateStringFormatter("dd MMM yyyy", experience.endDate!) : "Present"}"),
                    const SizedBox(height: 1.0),
                    smallText(experience.title, weight: FontWeight.w600),
                    const SizedBox(height: 1.0),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    onTapHandler(experience);
                    // edited stuffs,
                  },
                  child: const Icon(
                    Icons.edit_outlined,
                  ),
                )
              ],
            ),
            smallText(experience.companyName),
            const SizedBox(height: 5.0),
            smallText(experience.description),
          ],
        ),
      ),
    );
  }
}
