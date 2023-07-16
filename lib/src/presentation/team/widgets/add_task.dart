import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/date_picker.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';

class AddTaskBox extends StatefulWidget {
  final String taskTitle;
  final String startDate;
  final String endDate;
  final String description;
  final ActionTypes actionType;

  const AddTaskBox({
    super.key,
    required this.taskTitle,
    required this.startDate,
    required this.endDate,
    this.actionType = ActionTypes.create,
    required this.description,
  });

  @override
  State<AddTaskBox> createState() => _AddTaskBoxState();
}

class _AddTaskBoxState extends State<AddTaskBox> {
  final TextEditingController _taskTitle = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _startDateFocusNode = FocusNode();
  final FocusNode _endDateFocusNode = FocusNode();
  final FocusNode _taskFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _taskTitle.text = widget.taskTitle;
    _startDateController.text = widget.startDate;
    _endDateController.text = widget.endDate;
    _descriptionController.text = widget.description;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(children: [
          Center(child: subHeaderText("Add Task")),
          const SizedBox(height: 15),
          userInput_2(
            label: "Task Title",
            focusNode: _taskFocusNode,
            controller: _taskTitle,
          ),
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _taskFocusNode.unfocus();
                    });
                  },
                  child: DatePickerWidget(
                    controller: _startDateController,
                    focusNode: _startDateFocusNode,
                    label: "Start Date",
                    hint: '',
                    initialDate: _startDateController.text == ''
                        ? null
                        : DateTime.parse(_startDateController.text),
                    onChangedHandler: (value) {
                      setState(() {
                        _startDateController.text =
                            DateFormat('yyyy-MM-dd').format(value).toString();
                      });
                    },
                    lastDate: DateTime(2050),
                  )),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: const Text("—"),
            ),
            Expanded(
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _taskFocusNode.unfocus();
                    });
                  },
                  child: DatePickerWidget(
                    controller: _endDateController,
                    focusNode: _endDateFocusNode,
                    label: "End Date",
                    hint: '',
                    initialDate: _endDateController.text == ''
                        ? null
                        : DateTime.parse(_endDateController.text),
                    onChangedHandler: (value) {
                      setState(() {
                        _endDateController.text =
                            DateFormat('yyyy-MM-dd').format(value).toString();
                      });
                    },
                    lastDate: DateTime(2050),
                  )),
            )
          ]),
          userInput_2(
              label: "Description",
              controller: _descriptionController,
              size: 4),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ElevatedButton(
                child: bodyText(
                    widget.actionType == ActionTypes.create
                        ? "  Add  "
                        : "   Update   ",
                    weight: FontWeight.w500),
                onPressed: () {
                  DateTime startDate =
                      DateTime.parse(_startDateController.text);
                  DateTime endDate = DateTime.parse(_endDateController.text);

                  if (_taskTitle.text == '') {
                    confirmationBox(
                        context, "Failure", "Task title cannot be empty");
                  } else if (startDate.isAfter(endDate)) {
                    confirmationBox(context, "Failure",
                        "Start date cannot be after end date");
                  } else {
                    context.pop([
                      _taskTitle.text,
                      _startDateController.text,
                      _endDateController.text,
                      _descriptionController.text,
                    ]);
                  }
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
}
