import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/text/ll_body_text.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class ApplicantExperience extends StatelessWidget {
  final ExperienceEntity experienceData;
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
            LLBodyText(label:
                "${dateToDateFormatter(experienceData.startDate, noDate: true)} - ${experienceData.isCurrent ? 'Present' : dateToDateFormatter(experienceData.endDate, noDate: true)}",
                color: greyColor,
                size: 15.0),
            subHeaderText(experienceData.title, size: 15.0),
            LLBodyText(label: experienceData.companyName, size: 15.0),
            const SizedBox(height: 8),
            LLBodyText(label: experienceData.description, size: 14.0),
            const SizedBox(height: 20),
          ]),
        )
      ]),
    );
  }
}
