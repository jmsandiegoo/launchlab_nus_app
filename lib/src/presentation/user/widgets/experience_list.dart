import 'package:flutter/material.dart';
import 'package:launchlab/src/utils/helper.dart';

class ExperienceList extends StatelessWidget {
  const ExperienceList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExperienceCard(),
        OutlinedButton(
            onPressed: () => navigatePush(context, "/add-experience"),
            child: Text("Add"))
      ],
    );
  }
}

class ExperienceCard extends StatelessWidget {
  const ExperienceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Text("Expereince Card");
  }
}
