import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:launchlab/src/presentation/common/widgets/text/ll_body_text.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/utils/helper.dart';

class ManageRolesBox extends StatelessWidget {
  final String title;
  final String description;

  ManageRolesBox({super.key, required this.title, required this.description});

  final TextEditingController _taskTitle = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _taskTitle.text = title;
    _descriptionController.text = description;

    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(children: [
          Column(children: [
            _taskTitle.text == ''
                ? Center(child: subHeaderText("Add Role"))
                : Center(child: subHeaderText("Edit Role")),
            const SizedBox(height: 30),
            userInput_2(label: "Role Title", controller: _taskTitle),
            userInput_2(
                label: "Role Description",
                controller: _descriptionController,
                size: 4),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              ElevatedButton(
                  child: _taskTitle.text == ''
                      ? const LLBodyText(
                          label: "Add", fontWeight: FontWeight.w500)
                      : const LLBodyText(
                          label: "Update", fontWeight: FontWeight.w500),
                  onPressed: () {
                    if (_taskTitle.text == '') {
                      confirmationBox(context, "Try again",
                          "The Role Title field cannot be blank!");
                    } else {
                      context.pop([
                        _taskTitle.text,
                        _descriptionController.text,
                      ]);
                    }
                  }),
              OutlinedButton(
                child: const LLBodyText(label: "Close", fontWeight: FontWeight.w500),
                onPressed: () {
                  navigatePop(context);
                },
              ),
            ]),
          ]),
        ]),
      ),
    );
  }
}
