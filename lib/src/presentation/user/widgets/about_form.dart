import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/user/cubits/about_form_cubit.dart';

class AboutForm extends StatefulWidget {
  const AboutForm({super.key});

  @override
  State<AboutForm> createState() => _AboutFormState();
}

class _AboutFormState extends State<AboutForm> {
  late AboutFormCubit _aboutFormCubit;
  final _aboutFocusNode = FocusNode();
  final _aboutController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _aboutFormCubit = BlocProvider.of<AboutFormCubit>(context);

    _aboutFocusNode.addListener(() {
      if (!_aboutFocusNode.hasFocus) {
        _aboutFormCubit.onAboutUnfocused();
      }
    });
  }

  @override
  void dispose() {
    _aboutFocusNode.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AboutFormCubit, AboutFormState>(
      builder: ((context, state) {
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
                      headerText("Edit About"),
                      bodyText(
                          "Feel free to share your years of professional experience, industry knowledge, and skills."),
                    ],
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  flex: 2,
                  child: Image.asset(
                    "assets/images/about_form.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            TextFieldWidget(
              focusNode: _aboutFocusNode,
              controller: _aboutController,
              onChangedHandler: (value) =>
                  _aboutFormCubit.onAboutChanged(value),
              label: "",
              value: state.aboutInput.value,
              hint: "",
              errorText: state.aboutInput.displayError?.text(),
              size: 9,
            ),
            primaryButton(context, () {
              _aboutFormCubit.handleSubmit();
            }, "Save",
                isLoading: state.aboutFormStatus == AboutFormStatus.loading,
                elevation: 0),
          ],
        );
      }),
    );
  }
}
