import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/utils/helper.dart';

class DatePickerWidget extends StatelessWidget {
  const DatePickerWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.hint,
    required this.onChangedHandler,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.errorText,
    this.isEnabled = true,
  });

  final TextEditingController controller;
  final bool isEnabled;
  final FocusNode focusNode;
  final String label;
  final String hint;
  final String? errorText;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;
  final void Function(DateTime) onChangedHandler;

  @override
  Widget build(BuildContext context) {
    controller.text = initialDate != null
        ? dateStringFormatter("dd-MM-yyyy", initialDate!)
        : "";

    return SizedBox(
      height: 115,
      child: userInput(
        isEnabled: isEnabled,
        focusNode: FocusNode(),
        controller: controller,
        onChangedHandler: (p0) {},
        isReadOnly: true,
        hint: hint,
        label: label,
        errorText: errorText,
        onTapHandler: () => showDatePicker(
          context: context,
          initialDate: initialDate ?? DateTime.now(),
          firstDate: firstDate ?? DateTime(1923),
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
          controller.text = dateStringFormatter("dd-MM-yyyy", pickedDate);
          onChangedHandler(pickedDate);
        }),
        suffixWidget: const Icon(Icons.calendar_today_outlined),
      ),
    );
  }
}
