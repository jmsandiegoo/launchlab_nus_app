import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class EditIntro extends StatefulWidget {
  const EditIntro({super.key});

  @override
  State<EditIntro> createState() => _EditIntroState();
}

class _EditIntroState extends State<EditIntro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: blackColor),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 10),
            headerText("Edit Intro"),
            const SizedBox(height: 20),
            Center(child: profilePicture(100.0, "circle_profile_pic.png")),
            const SizedBox(height: 100),
            Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: bodyText("    Create    ")))
          ])),
    );
  }
}
