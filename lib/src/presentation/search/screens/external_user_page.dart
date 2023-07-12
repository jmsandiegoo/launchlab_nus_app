import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/team/widgets/applicant_accomplishment.dart';
import 'package:launchlab/src/presentation/team/widgets/applicant_experience.dart';
import 'package:launchlab/src/utils/helper.dart';

class ExternalUserPage extends StatelessWidget {
  final UserEntity userData;
  const ExternalUserPage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: blackColor),
          onPressed: () => navigatePop(context),
        ),
      ),
      body: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 3,
                              offset: const Offset(0, 3),
                            )
                          ]),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            userData.userAvatar == null
                                ? Image.asset('assets/images/avatar_temp.png')
                                : Image.network(
                                    userData.userAvatar!.signedUrl as String),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    headerText(
                                        '${userData.firstName} ${userData.lastName}',
                                        size: 27.0),
                                    bodyText(userData.title!),
                                    bodyText(userData.userDegreeProgramme!.name,
                                        color: greyColor),
                                  ]),
                            ),
                          ]),
                    ),
                    const SizedBox(height: 40),
                    subHeaderText('About Me'),
                    bodyText(userData.about!),
                    const SizedBox(height: 40),
                    userData.userExperiences.isEmpty
                        ? const SizedBox()
                        : Column(children: [
                            subHeaderText('Experience'),
                            const SizedBox(height: 10),
                            for (int i = 0;
                                i < userData.userExperiences.length;
                                i++) ...[
                              ApplicantExperience(
                                  experienceData: userData.userExperiences[i]),
                            ],
                            const SizedBox(height: 40),
                          ]),
                    subHeaderText('Skills'),
                    Container(
                      alignment: Alignment.topLeft,
                      child:
                          chipsWrap(userData.userPreference!.skillsInterests),
                    ),
                    const SizedBox(height: 40),
                    userData.userAccomplishments.isEmpty
                        ? const SizedBox()
                        : Column(children: [
                            subHeaderText('Achievement'),
                            const SizedBox(height: 10),
                            for (int i = 0;
                                i < userData.userAccomplishments.length;
                                i++) ...[
                              ApplicantAccomplishment(
                                  accomplishmentData:
                                      userData.userAccomplishments[i])
                            ],
                            const SizedBox(height: 40)
                          ]),
                    const SizedBox(height: 110),
                  ]),
            ),
          ),
        ),
      ]),
    );
  }
}
