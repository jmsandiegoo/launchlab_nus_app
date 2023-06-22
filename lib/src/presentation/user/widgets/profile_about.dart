import 'package:flutter/material.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class ProfileAbout extends StatelessWidget {
  const ProfileAbout({super.key, required this.userProfile});

  final UserEntity userProfile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        subHeaderText("About me"),
        bodyText(userProfile.about!),
      ],
    );
  }
}
