import 'package:flutter/cupertino.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/domain/user/models/major_entity.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/user/screens/accomplishment_list.dart';

class OnboardingStep4Page extends StatelessWidget {
  const OnboardingStep4Page({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingStep4Content();
  }
}

class OnboardingStep4Content extends StatefulWidget {
  const OnboardingStep4Content({super.key});

  @override
  State<OnboardingStep4Content> createState() => _OnboardingStep4ContentState();
}

class _OnboardingStep4ContentState extends State<OnboardingStep4Content> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        headerText("Share your accomplishments"),
        bodyText(
            "Also, feel free to share some accomplishments you have made such as CCAs, awards etc."),
        const SizedBox(
          height: 20.0,
        ),
        AccomplishmentList(accomplishments: [
          AccomplishmentEntity(
            "1",
            "Diploma with Merit",
            "Ngee Ann Polytechnic",
            false,
            DateTime.now(),
            DateTime.now(),
            null,
            DateTime.now(),
            DateTime.now(),
            const UserEntity("1", false, "Jm", "San Diego", "Developer",
                "avatar", "Resume", MajorEntity("1")),
          ),
        ])
      ],
    );
  }
}
