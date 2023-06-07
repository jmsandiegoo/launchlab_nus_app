import 'package:flutter/cupertino.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/dropwdown_search_field.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/multi_button_select.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class OnboardingStep2Page extends StatelessWidget {
  const OnboardingStep2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingStep2Content();
  }
}

class OnboardingStep2Content extends StatefulWidget {
  const OnboardingStep2Content({super.key});

  @override
  State<OnboardingStep2Content> createState() => _OnboardingStep2ContentState();
}

class _OnboardingStep2ContentState extends State<OnboardingStep2Content> {
  List<String> testValues = []; // change to cubit
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        headerText("State your skills & interests"),
        const SizedBox(
          height: 10.0,
        ),
        bodyText(
            "You can showcase your skills that you have learnt and also your interests."),
        const SizedBox(
          height: 20.0,
        ),
        DropdownSearchFieldMultiWidget(
          focusNode: FocusNode(),
          label: "",
          getItems: (String filter) async => ["Java", "Android", "Web Dev"],
          selectedItems: testValues,
          isChipsOutside: true,
          onChangedHandler: (values) => setState(() {
            testValues = values;
          }),
        ),
        const SizedBox(
          height: 20.0,
        ),
        headerText("Project Category"),
        const SizedBox(
          height: 10.0,
        ),
        bodyText(
            "Specify the kind of category you are interested to work in. You could select more than one."),
        const SizedBox(
          height: 20.0,
        ),
        MultiButtonMultiSelectWidget(
          values: const ["Startup", "Hackathons"],
          options: const [
            "Startup",
            "School Project",
            "Personal",
            "Hackathons",
            "Volunteer Work"
          ],
          colNo: 2,
          onPressHandler: (List<String> values) {},
        ),
      ],
    );
  }
}
