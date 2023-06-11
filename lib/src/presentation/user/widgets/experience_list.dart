import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/utils/helper.dart';

class ExperienceList extends StatelessWidget {
  const ExperienceList({
    super.key,
    required this.experiences,
  });

  final List<ExperienceEntity> experiences;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...() {
          return experiences
              .map((item) => ExperienceCard(experience: item))
              .toList();
        }(),
        LimitedBox(
          maxWidth: 100,
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: blackColor,
              ),
              onPressed: () => navigatePush(context, "/add-experience"),
              child: bodyText("Add", color: whiteColor)),
        )
      ],
    );
  }
}

class ExperienceCard extends StatelessWidget {
  const ExperienceCard({super.key, required this.experience});

  final ExperienceEntity experience;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10.0),
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
                        "${dateStringFormatter("MMM yyyy", experience.startDate)} — ${dateStringFormatter("MMM yyyy", experience.endDate!)}"),
                    const SizedBox(height: 1.0),
                    smallText(experience.title, weight: FontWeight.w600),
                    const SizedBox(height: 1.0),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    navigatePush(context, "/edit-experience");
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
