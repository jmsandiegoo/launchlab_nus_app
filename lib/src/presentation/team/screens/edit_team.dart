import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

import '../../../config/app_theme.dart';

//Create Page, but with data filled up from db

class EditTeamPage extends StatefulWidget {
  const EditTeamPage({super.key});

  @override
  State<EditTeamPage> createState() => _EditTeamPageState();
}

class _EditTeamPageState extends State<EditTeamPage> {
  int commitmentLevel = 1;
  String categoryInit = "School Project";

  var categories = [
    "School Project",
    "Personal Project",
    "Competition",
    "Startup",
    "Others"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: blackColor),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      headerText("Edit Team"),
                      bodyText("Need some changes?")
                    ],
                  ),
                  SizedBox(
                      height: 150,
                      child: SvgPicture.asset('assets/images/create_team.svg'))
                ]),
            const SizedBox(height: 20),
            userInput(label: "Team Name", hint: "Team Name"),
            userInput(
                label: "Description",
                size: 10,
                hint: "\n\n\n\nTeam Description"),
            userInput(label: "Dates Placeholder"),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("Category",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: blackColor)),
              const SizedBox(height: 5),
              SizedBox(
                height: 50.0,
                child: DropdownButtonFormField(
                  isDense: true,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 14),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: greyColor, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: greyColor, width: 1),
                    ),
                  ),
                  isExpanded: true,
                  value: categoryInit,
                  style: const TextStyle(color: blackColor, fontSize: 15),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: categories.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      categoryInit = newValue!;
                    });
                  },
                ),
              ),
            ]),
            const SizedBox(height: 30),
            subHeaderText("Commitment Level", size: 15.0),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              commitmentButton("    Low    ", 1),
              commitmentButton("  Medium  ", 2),
              commitmentButton("    High    ", 3),
            ]),
            const SizedBox(height: 30),
            userInput(label: "Interest Placeholder"),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                child: bodyText("   Update   "),
                onPressed: () {
                  debugPrint("Add to db here.");
                  Navigator.of(context).pop();
                },
              ),
            ),
            const SizedBox(height: 50),
          ]),
        ),
      ),
    );
  }

  Widget commitmentButton(text, level) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            backgroundColor:
                commitmentLevel == level ? blackColor : lightGreyColor),
        onPressed: () {
          setState(() {
            commitmentLevel = level;
          });
        },
        child: bodyText(text,
            size: 12.0,
            color: commitmentLevel == level ? whiteColor : blackColor));
  }
}
