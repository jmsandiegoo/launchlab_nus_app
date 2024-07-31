import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/team/team_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class TeamHomeItem extends StatelessWidget {
  const TeamHomeItem({super.key, required this.teamData, required this.onPressedHandler});

  final TeamEntity teamData;
  final void Function() onPressedHandler;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {onPressedHandler()},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: whiteColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                teamPicture(30, teamData.avatarURL, isUrl: true),
                const SizedBox(width: 20.0),
                smallText("${teamData.getMilestoneProgress()}% Progress"),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            subHeaderText(teamData.teamName),
            smallText(
                maxLines: 2,
                teamData.description.trim().isEmpty ? "No description provided." : teamData.description),
            const SizedBox(
              height: 10.0,
            ),
            smallText(fontStyle: FontStyle.italic, "23 Days Left"),
            Row(
              children: [
                const Icon(Icons.people_alt_outlined, size: 15.0),
                const SizedBox(width: 5),
                subHeaderText("${teamData.currentMembers} / ${teamData.maxMembers}", size: 13.0),
              ],
            )
          ],
        ),
      ),
    );
  }
}