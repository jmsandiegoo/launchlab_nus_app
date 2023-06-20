import 'package:flutter/material.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class SearchFilterBox extends StatelessWidget {
  final controller;

  const SearchFilterBox({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          subHeaderText("Filter"),
          const SizedBox(height: 15),
          GestureDetector(
              onTap: () {
                debugPrint("Clear All");
              },
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Clear All",
                        style: TextStyle(decoration: TextDecoration.underline))
                  ])),
          const SizedBox(height: 10),
          userInput_2(label: "Category Dropdown", controller: controller),
          userInput_2(label: "Commitment Dropdown"),
          userInput_2(label: "Interest Dropdown"),
          ElevatedButton(
            child: bodyText("  Done  "),
            onPressed: () {
              Navigator.of(context).pop(controller.text);
            },
          ),
        ]),
      ),
    );
  }
}
