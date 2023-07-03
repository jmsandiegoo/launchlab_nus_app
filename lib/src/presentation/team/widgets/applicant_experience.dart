import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/team/experience_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class ApplicantExperience extends StatelessWidget {
  final ExperienceTeamEntity experienceData;
  const ApplicantExperience({super.key, required this.experienceData});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(children: <Widget>[
        Container(
          width: 1,
          height: double.infinity,
          color: blackColor,
          margin: const EdgeInsets.only(right: 15),
        ),
        Flexible(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            bodyText(
                "${dateToDateFormatter(experienceData.startDate, noDate: true)} - ${experienceData.isCurrent ? 'Present' : dateToDateFormatter(experienceData.endDate, noDate: true)}",
                color: greyColor,
                size: 15.0),
            subHeaderText(experienceData.title, size: 15.0),
            bodyText(experienceData.companyName, size: 15.0),
            const SizedBox(height: 8),
            bodyText(experienceData.description, size: 14.0),
            const SizedBox(height: 30),
          ]),
        )
      ]),
    );
  }
}
