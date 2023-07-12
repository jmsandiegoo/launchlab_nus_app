import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/team/team_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class TeamHomeCard extends StatefulWidget {
  final TeamEntity teamData;
  const TeamHomeCard({super.key, required this.teamData});

  @override
  State<TeamHomeCard> createState() => _TeamHomeCardState();
}

class _TeamHomeCardState extends State<TeamHomeCard> {
  @override
  Widget build(BuildContext context) {
    String teamName = widget.teamData.teamName;
    String description = widget.teamData.description;
    int currentMember = widget.teamData.currentMembers;
    int maxMember = widget.teamData.maxMembers;
    String commitment = widget.teamData.commitment;
    String category = widget.teamData.category;
    String? endDate = widget.teamData.endDate != null
        ? dateToDateFormatter(widget.teamData.endDate)
        : null;
    String avatarURL = widget.teamData.avatarURL;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(children: [
        Container(
          decoration: const BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                teamPicture(40, avatarURL),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        subHeaderText(teamName),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(Icons.people_alt_outlined, size: 12),
                            const SizedBox(width: 5),
                            subHeaderText("$currentMember / $maxMember",
                                size: 12.0),
                          ],
                        )
                      ]),
                ),
              ]),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                boldFirstText("Category: ", category),
                endDate == null
                    ? boldFirstText("Deadline: ", 'None')
                    : boldFirstText("Deadline: ", endDate),
                const SizedBox(width: 5),
              ]),
              const SizedBox(height: 5),
              boldFirstText("Commitment Level: ", commitment),
              const SizedBox(height: 10),
              overflowText(description, color: darkGreyColor),
              const SizedBox(height: 15),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                bodyText("Progress ${widget.teamData.getMilestoneProgress()}%",
                    color: darkGreyColor, size: 12.0),
              ]),
            ]),
          ),
        ),
      ]),
    );
  }
}
