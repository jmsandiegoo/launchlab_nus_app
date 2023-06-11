import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/date_picker.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class AccomplishmentForm extends StatefulWidget {
  const AccomplishmentForm({
    super.key,
    required this.isEditMode,
  });

  final bool isEditMode;

  @override
  State<AccomplishmentForm> createState() => _AccomplishmentFormState();
}

class _AccomplishmentFormState extends State<AccomplishmentForm> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headerText(
                      "${widget.isEditMode ? "Edit" : "Add"} Accomplishment"),
                  bodyText(widget.isEditMode
                      ? "You can ammend your achievements or organisations you participated in below."
                      : "You can specify your achievements or organisations you participated in."),
                ],
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              flex: 2,
              child: Image.asset(
                "assets/images/accomplishment_form.png",
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        TextFieldWidget(
            focusNode: FocusNode(),
            onChangedHandler: (value) {},
            label: "Title Name",
            hint: "Ex: Best in CS1231S award"),
        TextFieldWidget(
            focusNode: FocusNode(),
            onChangedHandler: (value) {},
            label: "Issuer",
            hint: "Ex: National University of Singapore"),
        checkBox("Still Active", false, (p0) {}),
        const SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            Expanded(
              child: DatePickerWidget(
                controller: _startDateController,
                focusNode: FocusNode(),
                label: "Start Date",
                hint: '',
                onChangedHandler: (DateTime) {},
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: const Text("—"),
            ),
            Expanded(
              child: DatePickerWidget(
                controller: _endDateController,
                focusNode: FocusNode(),
                label: "End Date",
                hint: '',
                onChangedHandler: (DateTime) {},
              ),
            ),
          ],
        ),
        TextFieldWidget(
          focusNode: FocusNode(),
          onChangedHandler: (p0) {},
          label: "Description",
          hint: "Ex: Write something about the accomplishment etc.",
          size: 9,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            primaryButton(context, () => null, "Create", elevation: 0),
            ...() {
              return widget.isEditMode
                  ? [
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: errorColor)),
                        child: bodyText("Delete", color: errorColor),
                      ),
                    ]
                  : [];
            }()
          ],
        )
      ],
    );
  }
}
