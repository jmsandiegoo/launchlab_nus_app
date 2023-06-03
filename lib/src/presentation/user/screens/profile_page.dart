import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: const BoxDecoration(
                color: yellowColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                )),
            child: Column(children: [
              const SizedBox(height: 70),
              Row(
                children: [headerText("    My Profile")],
              ),
              const SizedBox(height: 10),
              profilePicture(110, 'circle_profile_pic.png'),
              headerText("John Doe"),
              const SizedBox(height: 5),
              bodyText("Web 3.0 Enthusiast"),
              bodyText("Computer Science", color: darkGreyColor),
            ]),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  subHeaderText("About me"),
                  const SizedBox(height: 5),
                  bodyText("Lorem ipsum dolor sit amet, consectetur adipiscing "
                      "elit, sed do eiusmod tempor incididunt ut labore et "
                      "dolore magna aliqua. Ut enim ad minim veniam, quis "
                      "nostrud exercitation ullamco laboris nisi ut aliquip ex "
                      "ea commodo consequat. Duis aute irure dolor in "
                      "reprehenderit in voluptate velit esse cillum dolore eu "
                      "fugiat nulla pariatur. Excepteur sint occaecat cupidatat "
                      "non proident, sunt in culpa qui officia deserunt mollit "
                      "anim id est laborum."),
                  const SizedBox(height: 20),
                  subHeaderText("Work Experience"),
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
                      child: bodyText(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing "
                          "elit, sed do eiusmod tempor incididunt ut labore et "
                          "dolore magna aliqua. Ut enim ad minim veniam, quis "
                          "nostrud exercitation ullamco laboris nisi ut aliquip ex "
                          "ea commodo consequat. Duis aute irure dolor in "
                          "reprehenderit in voluptate velit esse cillum dolore eu "
                          "fugiat nulla pariatur. Excepteur sint occaecat cupidatat "
                          "non proident, sunt in culpa qui officia deserunt mollit "
                          "anim id est laborum."),
                    ),
                  ])),
                  const SizedBox(height: 20),
                  subHeaderText("Accomplishment"),
                  const SizedBox(height: 5),
                  bodyText("Lorem ipsum dolor sit amet, consectetur adipiscing "
                      "elit, sed do eiusmod tempor incididunt ut labore et "
                      "dolore magna aliqua. Ut enim ad minim veniam, quis "
                      "nostrud exercitation ullamco laboris nisi ut aliquip ex "
                      "ea commodo consequat. Duis aute irure dolor in "
                      "reprehenderit in voluptate velit esse cillum dolore eu "
                      "fugiat nulla pariatur. Excepteur sint occaecat cupidatat "
                      "non proident, sunt in culpa qui officia deserunt mollit "
                      "anim id est laborum."),
                ],
              )),
        ]),
      ),
    );
  }
}
