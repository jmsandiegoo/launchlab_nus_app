import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({super.key});

  // Team Object

  // Team Chat object [messages] [users]

  // onTap Handler

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: whiteColor,
        ),
        child: Row(children: [
          profilePicture(
            50.0,
            "avatar_temp.png",
          ),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(
                  child: subHeaderText("Team Chat", size: 16.0, maxLines: 1),
                ),
                smallText("10:00 AM"),
              ]),
              const SizedBox(
                height: 5.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        smallText("Ricardo Santos (Owner)",
                            weight: FontWeight.bold, maxLines: 1),
                        smallText(
                            "A team to revolutionize the blockchain sp...",
                            alignment: TextAlign.left,
                            maxLines: 1),
                      ],
                    ),
                  ),
                  const Badge(
                    backgroundColor: yellowColor,
                    textColor: blackColor,
                    label: Text("1"),
                  )
                ],
              )
            ],
          ))
        ]),
      ),
    );
  }
}
