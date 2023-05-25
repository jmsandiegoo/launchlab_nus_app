import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/shared/widgets/useful.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _TeamChatPageState();
}

class _TeamChatPageState extends State<ChatPage> {
  int selectedButton = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Stack(children: [
          Image.asset("assets/images/yellow_curve_shape_3.png"),
          Column(children: [
            const SizedBox(
              height: 65,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.chat_rounded),
                const SizedBox(width: 5),
                headerText("Team Chat      ")
              ],
            ),
            const SizedBox(height: 15),
            Container(
              height: 45,
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Row(children: [
                searchBar(),
                const SizedBox(width: 0),
              ]),
            ),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                const SizedBox(width: 25),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor:
                          selectedButton == 1 ? blackColor : whiteColor,
                      side: const BorderSide(width: 1, color: blackColor)),
                  onPressed: () {
                    setState(() {
                      selectedButton = 1;
                    });
                  },
                  child: Text(
                    "Leading",
                    style: TextStyle(
                      color: selectedButton == 1 ? whiteColor : blackColor,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor:
                          selectedButton == 2 ? blackColor : whiteColor,
                      side: const BorderSide(width: 1, color: blackColor)),
                  onPressed: () {
                    setState(() {
                      selectedButton = 2;
                    });
                  },
                  child: Text(
                    "Participating",
                    style: TextStyle(
                      color: selectedButton == 2 ? whiteColor : blackColor,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor:
                          selectedButton == 3 ? blackColor : whiteColor,
                      side: const BorderSide(width: 1, color: blackColor)),
                  onPressed: () {
                    setState(() {
                      selectedButton = 3;
                    });
                  },
                  child: Text(
                    "Applicants Chat",
                    style: TextStyle(
                      color: selectedButton == 3 ? whiteColor : blackColor,
                      fontSize: 10,
                    ),
                  ),
                ),
              ]),
            ]),
          ]),
        ]),
        const SizedBox(height: 15),
      ]),
    );
  }
}
