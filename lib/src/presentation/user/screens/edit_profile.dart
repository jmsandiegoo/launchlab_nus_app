import 'package:flutter/material.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/user/screens/add_experience.dart';
import 'package:launchlab/src/presentation/user/screens/edit_about.dart';
import 'package:launchlab/src/presentation/user/screens/edit_experience.dart';
import 'package:launchlab/src/presentation/user/screens/edit_intro.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      const SizedBox(height: 100),
      ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const EditAbout()));
          },
          child: bodyText("Edit About")),
      ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddExperience()));
          },
          child: bodyText("Add Experience")),
      ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EditExperience()));
          },
          child: bodyText("Edit Experience")),
      ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const EditIntro()));
          },
          child: bodyText("Edit Intro")),
      ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: bodyText("Back")),
    ]));
  }
}
