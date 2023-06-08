import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/utils/helper.dart';

class DatePickerWidget extends StatelessWidget {
  const DatePickerWidget(
      {super.key,
      required this.controller,
      required this.focusNode,
      required this.label,
      required this.hint,
      this.firstDate,
      this.lastDate,
      this.initialDate});

  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String hint;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;

  @override
  Widget build(BuildContext context) {
    controller.text = "";

    return userInput(
      focusNode: FocusNode(),
      controller: controller,
      onChangedHandler: (p0) {},
      isReadOnly: true,
      hint: hint,
      label: label,
      onTapHandler: () => showDatePicker(
        context: context,
        initialDate: initialDate ?? DateTime.now(),
        firstDate: firstDate ?? DateTime(2000),
        lastDate: lastDate ?? DateTime.now(),
        builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
              brightness: Brightness.dark,
              colorScheme: const ColorScheme.dark(
                primary: yellowColor,
                onPrimary: blackColor,
                onSurface: whiteColor,
              ),
              dialogBackgroundColor: blackColor,
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(foregroundColor: yellowColor),
              ),
              textTheme:
                  const TextTheme(titleMedium: TextStyle(color: whiteColor))),
          child: child!,
        ),
      ).then((pickedDate) {
        if (pickedDate == null) {
          return;
        }
        controller.text = dateStringFormatter("MM-dd-yyyy", pickedDate);
        // call onChanged handler here.
      }),
      suffixWidget: const Icon(Icons.calendar_today_outlined),
    );
  }
}
