import 'package:flutter/cupertino.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/date_picker.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class ExperienceForm extends StatefulWidget {
  const ExperienceForm({super.key});

  @override
  State<ExperienceForm> createState() => _ExperienceFormState();
}

class _ExperienceFormState extends State<ExperienceForm> {
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
                  headerText("Add Experience"),
                  bodyText(
                      "Specify your work experience below so to display it on your profile.")
                ],
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              flex: 2,
              child: Image.asset(
                "assets/images/experience_form.png",
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
            hint: "Ex: Frontend Developer"),
        TextFieldWidget(
            focusNode: FocusNode(),
            onChangedHandler: (value) {},
            label: "Company Name",
            hint: "Ex: Google"),
        Row(
          children: [
            Expanded(
              child: DatePickerWidget(
                controller: _startDateController,
                focusNode: FocusNode(),
                label: "Start Date",
                hint: '',
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
              ),
            ),
          ],
        )
      ],
    );
  }
}
