import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/search/search_team_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class SearchTeamCard extends StatelessWidget {
  final SearchTeamEntity data;
  const SearchTeamCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    String teamName = data.teamName;
    int currentMember = data.currentMembers;
    int maxMember = data.maxMembers;
    String commitment = data.commitment;
    String category = data.category;
    String allInterest = data.getInterests();
    String allRoles = data.getRoles();
    String avatarURL = data.avatarURL;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            teamPicture(40, avatarURL, isUrl: true),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              subHeaderText(teamName),
              const SizedBox(height: 5),
              Row(children: [
                const Icon(Icons.people_alt_outlined, size: 12),
                const SizedBox(width: 5),
                subHeaderText("$currentMember / $maxMember", size: 12.0),
              ]),
            ]),
          ]),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            boldFirstText("Category: ", category),
            const SizedBox(),
            boldFirstText("Commitment: ", commitment),
            const SizedBox()
          ]),
          const SizedBox(height: 10),
          subHeaderText("Roles Needed: ", size: 12.0),
          allRoles == ''
              ? overflowText('Any', size: 12.0, maxLines: 1)
              : overflowText(allRoles, size: 12.0, maxLines: 1),
          const SizedBox(height: 5),
          subHeaderText("Interest: ", size: 12.0),
          overflowText(allInterest, size: 12.0, maxLines: 2),
        ]),
      ),
    );
  }
}
