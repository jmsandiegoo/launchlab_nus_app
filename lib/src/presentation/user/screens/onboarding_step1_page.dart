import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/dropwdown_search_field.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/picture_upload_picker.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/user/cubits/onboarding_step1_page_cubit.dart';

class OnboardingStep1Page extends StatelessWidget {
  const OnboardingStep1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingStep1PageCubit(),
      child: const OnboardingStep1Content(),
    );
  }
}

class OnboardingStep1Content extends StatefulWidget {
  const OnboardingStep1Content({super.key});

  @override
  State<OnboardingStep1Content> createState() => _OnboardingStep1ContentState();
}

class _OnboardingStep1ContentState extends State<OnboardingStep1Content> {
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _titleFocusNode = FocusNode();
  final _majorFocusNode = FocusNode();
  final _aboutFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    final onboardingStep1PageCubit =
        BlocProvider.of<OnboardingStep1PageCubit>(context);

    _firstNameFocusNode.addListener(() {
      if (!_firstNameFocusNode.hasFocus) {
        onboardingStep1PageCubit.onFirstNameUnfocused();
      }
    });

    _lastNameFocusNode.addListener(() {
      if (!_lastNameFocusNode.hasFocus) {
        onboardingStep1PageCubit.onLastNameUnfocused();
      }
    });

    _titleFocusNode.addListener(() {
      if (!_titleFocusNode.hasFocus) {
        onboardingStep1PageCubit.onTitleUnfocused();
      }
    });
  }

  @override
  void dispose() {
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingStep1PageCubit, OnboardingStep1PageState>(
      builder: (context, state) {
        final onboardingStep1PageCubit =
            BlocProvider.of<OnboardingStep1PageCubit>(context);
        return ListView(
          children: [
            headerText("Tell us about yourself"),
            // Profile Photo Picker
            const SizedBox(
              height: 30,
            ),
            PictureUploadPickerWidget(
              onPictureUploadChangedHandler: (image) =>
                  onboardingStep1PageCubit.onPictureUploadChanged(image),
              image: state.pictureUploadPickerInput.value,
            ),
            const SizedBox(
              height: 30,
            ),
            TextFieldWidget(
              focusNode: _firstNameFocusNode,
              onChangedHandler: (val) =>
                  onboardingStep1PageCubit.onFirstNameChanged(val),
              label: "First Name",
              hint: "Ex: John",
            ),
            TextFieldWidget(
              focusNode: _lastNameFocusNode,
              onChangedHandler: (val) =>
                  onboardingStep1PageCubit.onLastNameChanged(val),
              label: "Last Name",
              hint: "Ex: Doe",
            ),
            TextFieldWidget(
              focusNode: _titleFocusNode,
              onChangedHandler: (val) =>
                  onboardingStep1PageCubit.onTitleChanged(val),
              label: "Title",
              hint: "Ex: Software Developer",
            ),
            DropdownSearchFieldWidget(
                focusNode: _majorFocusNode,
                label: "Major",
                getItems: (String filter) async =>
                    ["Accounting", "Computer Science", "Information Systems"],
                selectedItem: "",
                onChangedHandler: (val) => print("onchange dropdown")),
            headerText("Make an about me"),
            const SizedBox(
              height: 10.0,
            ),
            bodyText(
                "Feel free to share your years of professional experience, industry knowledge, and skills. Additionally, you have the opportunity to share something interesting about yourself!"),
            const SizedBox(height: 10.0),
            TextFieldWidget(
              focusNode: _aboutFocusNode,
              onChangedHandler: (val) => {},
              label: "",
              hint: "",
              size: 10,
            )
          ],
        );
      },
    );
  }
}
