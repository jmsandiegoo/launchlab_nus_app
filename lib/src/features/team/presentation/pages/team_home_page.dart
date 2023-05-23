import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';


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
      body: SingleChildScrollView(
        child: Column(children: [
          Stack(
            children: <Widget>[
              Image.asset("assets/images/yellow_curve_shape.png"),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SvgPicture.asset("assets/images/homepage_skateboard.svg"),
                      const SizedBox(width: 20),
                    ],
                  )
                ],
              ),

              Positioned(
                top: 150,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Hi XXX",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Check out your awesome team!",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              const SizedBox(width: 25),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor: isLeading ? blackColor : whiteColor),
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
                    backgroundColor: isLeading ? whiteColor : blackColor),
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

        //Implement the team cards here
        ]),

      ),
    );
  }
}

