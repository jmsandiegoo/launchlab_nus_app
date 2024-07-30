import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/text/ll_body_text.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class ApplicantAccomplishment extends StatelessWidget {
  final AccomplishmentEntity accomplishmentData;
  const ApplicantAccomplishment({super.key, required this.accomplishmentData});

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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          LLBodyText(label:
              "${dateToDateFormatter(accomplishmentData.startDate, noDate: true)} - ${accomplishmentData.isActive ? 'Present' : dateToDateFormatter(accomplishmentData.endDate, noDate: true)}",
              color: greyColor,
              size: 15.0),
          subHeaderText(accomplishmentData.title, size: 15.0),
          LLBodyText(label: accomplishmentData.issuer, size: 15.0),
          const SizedBox(height: 8),
          LLBodyText(label: accomplishmentData.description!, size: 14.0),
          const SizedBox(height: 20)
        ]),
      ),
    ]));
  }
}
