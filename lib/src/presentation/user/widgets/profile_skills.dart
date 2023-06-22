import 'package:flutter/material.dart';
import 'package:launchlab/src/domain/common/models/skill_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class ProfileSkills extends StatelessWidget {
  const ProfileSkills({
    super.key,
    required this.skillsInterests,
  });

  final List<SkillEntity> skillsInterests;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [subHeaderText("Skills")],
        ),
        const SizedBox(height: 5),
        chipsWrap(skillsInterests),
      ],
    );
  }
}
