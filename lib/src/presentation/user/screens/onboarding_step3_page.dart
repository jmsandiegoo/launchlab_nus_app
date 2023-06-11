import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/domain/user/models/major_entity.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/file_upload.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/user/widgets/experience_list.dart';

class OnboardingStep3Page extends StatelessWidget {
  const OnboardingStep3Page({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingStep3Content();
  }
}

class OnboardingStep3Content extends StatefulWidget {
  const OnboardingStep3Content({super.key});

  @override
  State<OnboardingStep3Content> createState() => _OnboardingStep3ContentState();
}

class _OnboardingStep3ContentState extends State<OnboardingStep3Content> {
  File? selectedFile = null;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        headerText("Upload Resume"),
        const SizedBox(
          height: 20.0,
        ),
        FileUploadWidget(
          selectedFile: selectedFile,
          onFileUploadChangedHandler: (value) => setState(() {
            selectedFile = value;
          }),
        ),
        const SizedBox(
          height: 20.0,
        ),
        headerText("Share your experience"),
        bodyText(
            "You can choose to share some work experiences you have for other users to see."),
        const SizedBox(
          height: 20.0,
        ),
        ExperienceList(
          experiences: [
            ExperienceEntity(
              "1",
              "Developer",
              "Koios Pte. Ltd.",
              false,
              DateTime.now(),
              DateTime.now(),
              "My own description",
              DateTime.now(),
              DateTime.now(),
              const UserEntity("1", false, "Jm", "San Diego", "Developer",
                  "avatar", "Resume", MajorEntity("1")),
            )
          ],
        ),
      ],
    );
  }
}
