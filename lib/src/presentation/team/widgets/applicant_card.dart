import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class ApplicantCard extends StatelessWidget {
  final UserEntity applicantData;
  const ApplicantCard({super.key, required this.applicantData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 3,
              offset: const Offset(0, 3),
            )
          ]),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Row(children: [
            applicantData.userAvatar == null
                ? profilePicture(40.0, '', isUrl: true)
                : profilePicture(40.0, applicantData.userAvatar!.signedUrl!,
                    isUrl: true),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                subHeaderText(
                    "${applicantData.firstName} ${applicantData.lastName}",
                    size: 16.0),
                bodyText(applicantData.title!, size: 13.0)
              ],
            )
          ]),
        ]),
      ),
    );
  }
}
