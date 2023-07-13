import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/utils/helper.dart';

class ChatPageHeader extends StatelessWidget {
  const ChatPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      decoration: const BoxDecoration(color: yellowColor),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            GestureDetector(
                onTap: () {
                  navigatePop(context);
                },
                child: const Icon(Icons.keyboard_backspace_outlined)),
            teamPicture(40.0, "team_avatar_temp.png"),
          ]),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              profilePicture(50.0, "avatar_temp.png"),
              const SizedBox(
                width: 15.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headerText("Jm San Diego"),
                  bodyText("Tech Lead", color: greyColor.shade700)
                ],
              )
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}
