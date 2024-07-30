import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/team/team_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class TeamHomeItem extends StatelessWidget {
  const TeamHomeItem({super.key, required this.teamData});

  final TeamEntity teamData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {},
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

// class _TeamHomeCardState extends State<StatefulWidget> {
//   @override
//   Widget build(BuildContext context) {
//     String teamName = widget.teamData.teamName;
//     String description = widget.teamData.description;
//     int currentMember = widget.teamData.currentMembers;
//     int maxMember = widget.teamData.maxMembers;
//     String commitment = widget.teamData.commitment;
//     String category = widget.teamData.category;
//     String? endDate = widget.teamData.endDate != null
//         ? dateToDateFormatter(widget.teamData.endDate)
//         : null;
//     String avatarURL = widget.teamData.avatarURL;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 25),
//       child: Column(children: [
//         Container(
//           decoration: const BoxDecoration(
//               color: whiteColor,
//               borderRadius: BorderRadius.all(Radius.circular(10))),
//           width: double.infinity,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Row(children: [
//                 teamPicture(40, avatarURL, isUrl: true),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         subHeaderText(teamName),
//                         const SizedBox(height: 3),
//                         Row(
//                           children: [
//                             const Icon(Icons.people_alt_outlined, size: 12),
//                             const SizedBox(width: 5),
//                             subHeaderText("$currentMember / $maxMember",
//                                 size: 12.0),
//                           ],
//                         )
//                       ]),
//                 ),
//               ]),
//               const SizedBox(height: 10),
//               Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                 boldFirstText("Category: ", category),
//                 endDate == null
//                     ? boldFirstText("Deadline: ", 'None')
//                     : boldFirstText("Deadline: ", endDate),
//                 const SizedBox(width: 5),
//               ]),
//               const SizedBox(height: 5),
//               boldFirstText("Commitment Level: ", commitment),
//               const SizedBox(height: 10),
//               overflowText(description, color: darkGreyColor),
//               const SizedBox(height: 15),
//               Row(mainAxisAlignment: MainAxisAlignment.end, children: [
//                 bodyText("Progress ${widget.teamData.getMilestoneProgress()}%",
//                     color: darkGreyColor, size: 12.0),
//               ]),
//             ]),
//           ),
//         ),
//       ]),
//     );
//   }
// }
