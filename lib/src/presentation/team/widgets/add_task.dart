import 'package:flutter/material.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class AddTaskBox extends StatelessWidget {
  final controller;

  AddTaskBox({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          subHeaderText("Add Task"),
          const SizedBox(height: 30),
          userInput(label: "Task Title", controller: controller),
          userInput(label: "Info 2 Placeholder"),
          userInput(label: "Info 3 Placeholder"),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ElevatedButton(
              child: bodyText("  Add  "),
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
            ),
            OutlinedButton(
              child: bodyText("  Close  "),
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
            ),
          ]),
        ]),
      ),
    );
  }
}
