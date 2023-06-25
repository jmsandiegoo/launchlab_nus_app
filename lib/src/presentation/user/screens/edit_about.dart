import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class EditAbout extends StatefulWidget {
  const EditAbout({super.key});

  @override
  State<EditAbout> createState() => _EditAboutState();
}

class _EditAboutState extends State<EditAbout> {
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
                              headerText("Edit About"),
                              const SizedBox(height: 10),
                              bodyText(
                                  "Feel free to share your years of professional "
                                  "experience, industry knowledge, and skills. "
                                  "Additionally, you have the opportunity to share "
                                  "something interesting about yourself!",
                                  size: 13.0)
                            ])),
                    SvgPicture.asset('assets/images/edit_about.svg')
                  ]),
              const SizedBox(height: 100),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: bodyText("    Save    "))
            ]),
          ),
        ));
  }
}
