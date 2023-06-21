import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/user/screens/edit_profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            Container(
              height: 350,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: yellowColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  )),
              child: Column(children: [
                const SizedBox(height: 90),
                const SizedBox(height: 10),
                profilePicture(100, 'circle_profile_pic.png'),
                headerText("John Doe"),
                const SizedBox(height: 5),
                bodyText("Web 3.0 Enthusiast"),
                bodyText("Computer Science", color: darkGreyColor),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        teamStatusBar(
                            "Completed", "5", Icons.check_circle_sharp),
                        teamStatusBar("Leading", "4", Icons.people_alt),
                        teamStatusBar(
                            "Participating", "4", Icons.handshake_outlined),
                      ]),
                ),
              ]),
            ),
            AppBar(
                backgroundColor: yellowColor,
                centerTitle: false,
                title: headerText("My Profile"),
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EditProfile()),
                        );
                        debugPrint("AppBar");
                      },
                      icon: const Icon(Icons.edit_outlined, color: blackColor))
                ]),
          ]),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          subHeaderText("About me"),
                          const Icon(Icons.edit_outlined, color: blackColor)
                        ]),
                    const SizedBox(height: 5),
                    bodyText(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing "
                        "elit, sed do eiusmod tempor incididunt ut labore et "
                        "dolore magna aliqua. Ut enim ad minim veniam, quis "
                        "nostrud exercitation ullamco laboris nisi ut aliquip ex "
                        "ea commodo consequat. Duis aute irure dolor in "
                        "reprehenderit in voluptate velit esse cillum dolore eu "
                        "fugiat nulla pariatur. Excepteur sint occaecat cupidatat "
                        "non proident, sunt in culpa qui officia deserunt mollit "
                        "anim id est laborum."),
                    const SizedBox(height: 20),
                    subHeaderText("Experience"),
                    const SizedBox(height: 5),
                    IntrinsicHeight(
                        child: Row(children: <Widget>[
                      Container(
                        width: 2,
                        height: double.infinity,
                        color: blackColor,
                        margin: const EdgeInsets.only(right: 15),
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            bodyText("Jan 2022 - Jun 2022",
                                color: greyColor, size: 15.0),
                            subHeaderText("FrontEnd Developer", size: 15.0),
                            bodyText("National University of Singapore",
                                size: 15.0),
                            const SizedBox(height: 8),
                            bodyText(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing "
                                "elit, sed do eiusmod tempor incididunt ut labore et "
                                "dolore magna aliqua. Ut enim ad minim veniam, quis "
                                "nostrud exercitation ullamco laboris nisi ut aliquip ex "
                                "ea commodo consequat. Duis aute irure dolor in "
                                "reprehenderit in voluptate velit esse cillum dolore eu "
                                "fugiat nulla pariatur. Excepteur sint occaecat cupidatat "
                                "non proident, sunt in culpa qui officia deserunt mollit "
                                "anim id est laborum.",
                                size: 14.0),
                            const SizedBox(height: 30),
                            bodyText("Jan 2022 - Jun 2022",
                                color: greyColor, size: 15.0),
                            subHeaderText("FrontEnd Developer", size: 15.0),
                            bodyText("National University of Singapore",
                                size: 15.0),
                            const SizedBox(height: 8),
                            bodyText(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing "
                                "elit, sed do eiusmod tempor incididunt ut labore et "
                                "dolore magna aliqua. Ut enim ad minim veniam, quis "
                                "nostrud exercitation ullamco laboris nisi ut aliquip ex "
                                "ea commodo consequat. Duis aute irure dolor in "
                                "reprehenderit in voluptate velit esse cillum dolore eu "
                                "fugiat nulla pariatur. Excepteur sint occaecat cupidatat "
                                "non proident, sunt in culpa qui officia deserunt mollit "
                                "anim id est laborum.",
                                size: 14.0),
                          ],
                        ),
                      ),
                    ])),
                    const SizedBox(height: 20),
                    subHeaderText("Skills"),
                    const SizedBox(height: 5),
                    Container(
                      color: Colors.blue,
                      alignment: Alignment.center,
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          OutlinedButton(
                              onPressed: () {},
                              child: bodyText("Placeholder1", size: 10.0)),
                          OutlinedButton(
                              onPressed: () {},
                              child: bodyText("Placeholder2", size: 10.0)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    subHeaderText("Accomplishment"),
                    const SizedBox(height: 5),
                    bodyText(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing "
                        "elit, sed do eiusmod tempor incididunt ut labore et "
                        "dolore magna aliqua. Ut enim ad minim veniam, quis "
                        "nostrud exercitation ullamco laboris nisi ut aliquip ex "
                        "ea commodo consequat. Duis aute irure dolor in "
                        "reprehenderit in voluptate velit esse cillum dolore eu "
                        "fugiat nulla pariatur. Excepteur sint occaecat cupidatat "
                        "non proident, sunt in culpa qui officia deserunt mollit "
                        "anim id est laborum."),
                  ])),
        ]),
      ),
    );
  }

  Widget teamStatusBar(textLabel, textNum, icon) {
    return Container(
        height: 50,
        width: 90,
        decoration: const BoxDecoration(
            color: blackColor,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                textLabel,
                style: const TextStyle(fontSize: 12.0, color: yellowColor),
              ),
              const SizedBox(height: 3),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(icon, color: yellowColor, size: 12.0),
                const SizedBox(width: 2),
                Text(
                  textNum,
                  style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: yellowColor),
                )
              ])
            ]));
  }
}
