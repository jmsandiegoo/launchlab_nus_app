import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class AddExperience extends StatefulWidget {
  const AddExperience({super.key});

  @override
  State<AddExperience> createState() => _AddExperienceState();
}

class _AddExperienceState extends State<AddExperience> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: blackColor),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                        flex: 1,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              headerText("Add Experience"),
                              const SizedBox(height: 10),
                              bodyText(
                                  "Specify your work experience below so to"
                                  "display it on your profile.",
                                  size: 13.0)
                            ])),
                    SvgPicture.asset('assets/images/edit_experience.svg')
                  ]),
              const SizedBox(height: 100),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: bodyText("    Create    "))
            ]),
          ),
        ));
  }
}
