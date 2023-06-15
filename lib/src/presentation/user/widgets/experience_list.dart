import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';

class ExperienceList extends StatelessWidget {
  const ExperienceList({
    super.key,
    required this.experiences,
    required this.onChangedHandler,
  });

  final List<ExperienceEntity> experiences;
  final void Function(List<ExperienceEntity>) onChangedHandler;

  Future<void> addExperience(BuildContext context) async {
    final returnData = await navigatePush(context, "/onboard-add-experience");

    if (returnData == null) {
      return;
    }

    if (returnData.actionType == ActionTypes.create) {
      final newExperiences = [...experiences];
      newExperiences.add(returnData.data);
      onChangedHandler(newExperiences);
    }
  }

  Future<void> editExperience(
      BuildContext context, ExperienceEntity exp) async {
    final NavigationData<ExperienceEntity>? returnData =
        await navigatePushWithData<ExperienceEntity>(
            context, "/onboard-edit-experience", exp);

    List<ExperienceEntity> newExperiences = [...experiences];
    final index = newExperiences.indexOf(exp);

    if (returnData == null) {
      return;
    }

    if (returnData.actionType == ActionTypes.update) {
      newExperiences[index] = returnData.data!;
      onChangedHandler(newExperiences);
    }

    if (returnData.actionType == ActionTypes.delete) {
      newExperiences.removeAt(index);
      onChangedHandler(newExperiences);
    }
  }

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
                  experience: item,
                  onTapHandler: (context, exp) => editExperience(context, exp)))
              .toList();
        }(),
        LimitedBox(
          maxWidth: 100,
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: blackColor,
              ),
              onPressed: () {
                addExperience(context);
              },
              child: bodyText("Add", color: whiteColor)),
        )
      ],
    );
  }
}

class ExperienceCard extends StatelessWidget {
  const ExperienceCard(
      {super.key, required this.experience, required this.onTapHandler});

  final ExperienceEntity experience;
  final void Function(BuildContext, ExperienceEntity) onTapHandler;

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
                        "${dateStringFormatter("MMM yyyy", experience.startDate)} - ${experience.endDate != null ? dateStringFormatter("MMM yyyy", experience.endDate!) : "Present"}"),
                    const SizedBox(height: 1.0),
                    smallText(experience.title, weight: FontWeight.w600),
                    const SizedBox(height: 1.0),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    onTapHandler(context, experience);
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
