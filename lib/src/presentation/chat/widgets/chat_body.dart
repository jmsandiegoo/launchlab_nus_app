import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class ChatBody extends StatelessWidget {
  const ChatBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            SizedBox(
              height: 20.0,
            ),
            ChatBubble()
          ],
        ));
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          Expanded(
              flex: 3,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  profilePicture(35.0, "avatar_temp.png"),
                  const SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: whiteColor),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: smallText(
                                  "Jm San Diego",
                                  weight: FontWeight.bold,
                                  maxLines: 2,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: smallText(
                                  "A team to revolutionize the blockch technology.",
                                  overflow: null,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
          Expanded(flex: 1, child: Container()),
        ],
      ),
    );
  }
}
