import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/utils/helper.dart';

class AddTaskBox extends StatefulWidget {
  const AddTaskBox({super.key});

  @override
  State<AddTaskBox> createState() => _AddTaskBoxState();
}

class _AddTaskBoxState extends State<AddTaskBox> {
  final TextEditingController _taskTitle = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 450,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(children: [
          subHeaderText("Add Task"),
          const SizedBox(height: 30),
          userInput_2(label: "Task Title", controller: _taskTitle),
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            datePicker("Start Date", _startDateController),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: const Text("\n—"),
            ),
            datePicker("End Date", _endDateController),
          ]),
          const SizedBox(height: 30),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ElevatedButton(
                child: bodyText("  Add  ", weight: FontWeight.w500),
                onPressed: () {
                  context.pop([
                    _taskTitle.text,
                    _startDateController.text,
                    _endDateController.text
                  ]);
                }),
            OutlinedButton(
              child: bodyText("  Close  ", weight: FontWeight.w500),
              onPressed: () {
                navigatePop(context);
              },
            ),
          ]),
        ]),
      ),
    );
  }

  Widget datePicker(label, controller) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: blackColor)),
        const SizedBox(height: 5),
        Center(
            child: TextField(
          controller: controller,
          focusNode: FocusNode(),
          decoration: const InputDecoration(
            filled: true,
            fillColor: whiteColor,
            suffixIcon: Icon(Icons.calendar_today_outlined),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: lightGreyColor,
              ),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: lightGreyColor)),
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100));

            if (pickedDate != null) {
              setState(() {
                controller.text = dateToDateFormatter(pickedDate);
              });
            }
          },
        )),
      ],
    ));
  }
}
