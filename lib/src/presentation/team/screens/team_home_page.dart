import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class TeamHomePage extends StatefulWidget {
  const TeamHomePage({Key? key}) : super(key: key);

  @override
  State<TeamHomePage> createState() => _TeamHomePageState();
}

class _TeamHomePageState extends State<TeamHomePage> {
  bool isLeading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreyColor,
      body: SingleChildScrollView(
        child: Column(children: [
          Stack(
            children: <Widget>[
              Image.asset("assets/images/yellow_curve_shape_3.png"),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                const SizedBox(height: 60),
                Row(children: [
                  const SizedBox(width: 20),
                  profilePicture(45, "assets/images/circle_profile_pic.png"),
                ]),
              ]),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerRight,
                  child:
                      SvgPicture.asset('assets/images/skateboard_homepage.svg'),
                ),
              ),
              Positioned(
                top: 130,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerText("Hi XXX", size: 30.0),
                    const Text(
                      "Check out your awesome \nteams!",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              const SizedBox(width: 25),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor: isLeading ? blackColor : whiteColor,
                    side: const BorderSide(width: 1, color: blackColor)),
                onPressed: () {
                  setState(() {
                    isLeading = true;
                  });
                },
                child: Text(
                  "Leading",
                  style: TextStyle(
                    color: isLeading ? whiteColor : blackColor,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor: isLeading ? whiteColor : blackColor,
                    side: const BorderSide(width: 1, color: blackColor)),
                onPressed: () {
                  setState(() {
                    isLeading = false;
                  });
                },
                child: Text(
                  "Participating",
                  style: TextStyle(
                    color: isLeading ? blackColor : whiteColor,
                    fontSize: 10,
                  ),
                ),
              ),
            ]),
            Row(children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(backgroundColor: yellowColor),
                onPressed: () {
                  //To navigate to create team page.
                },
                child: const Text(
                  "Create Team",
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(width: 25),
            ]),
          ]),

          //Team Cards

          isLeading
              ? Column(children: [
                  const SizedBox(height: 150),
                  headerText("Uh oh. \nNo Leading Teams Found!",
                      alignment: TextAlign.center)
                ])
              : GestureDetector(
                  onTap: () {
                    debugPrint("Go to Teams Page");
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 20),
                    child: Column(children: [
                      Container(
                        width: double.infinity,
                        color: whiteColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  profilePicture(35, "assets/images/test.jpeg"),
                                  const SizedBox(width: 10),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        subHeaderText("Project Rama"),
                                        const SizedBox(height: 5),
                                        bodyText("Progress 50%",
                                            color: darkGreyColor, size: 12.0),
                                      ])
                                ]),
                                const SizedBox(height: 15),
                                bodyText(
                                    "Lorem ipsum dolor sit amet, consectetur adipiscing "
                                    "elit, sed do eiusmod tempor incididunt",
                                    color: darkGreyColor),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    const Icon(Icons.people_alt_outlined,
                                        size: 20),
                                    const SizedBox(width: 10),
                                    subHeaderText("2 / 2", size: 15.0),
                                  ],
                                )
                              ]),
                        ),
                      ),
                    ]),
                  ),
                )
        ]),
      ),
    );
  }
}
