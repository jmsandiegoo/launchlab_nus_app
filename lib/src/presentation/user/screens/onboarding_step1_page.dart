import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/dropwdown_search_field.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/picture_upload_picker.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/degree_programme_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/username_field.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/user/cubits/onboarding_cubit.dart';

class OnboardingStep1Page extends StatelessWidget {
  const OnboardingStep1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      // ignore: prefer_const_constructors
      builder: (context, state) => OnboardingStep1Content(),
    );
  }
}

class OnboardingStep1Content extends StatefulWidget {
  const OnboardingStep1Content({super.key});

  @override
  State<OnboardingStep1Content> createState() => _OnboardingStep1ContentState();
}

class _OnboardingStep1ContentState extends State<OnboardingStep1Content> {
  late OnboardingCubit _onboardingCubit;
  final _usernameFocusNode = FocusNode();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _titleFocusNode = FocusNode();
  final _degreeProgrammeFocusNode = FocusNode();
  final _aboutFocusNode = FocusNode();

  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _titleController = TextEditingController();
  final _aboutController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _onboardingCubit = BlocProvider.of<OnboardingCubit>(context);

    _usernameFocusNode.addListener(() {
      if (!_usernameFocusNode.hasFocus) {
        _onboardingCubit.onUsernameUnfocused();
      }
    });

    _firstNameFocusNode.addListener(() {
      if (!_firstNameFocusNode.hasFocus) {
        _onboardingCubit.onFirstNameUnfocused();
      }
    });

    _lastNameFocusNode.addListener(() {
      if (!_lastNameFocusNode.hasFocus) {
        _onboardingCubit.onLastNameUnfocused();
      }
    });

    _titleFocusNode.addListener(() {
      if (!_titleFocusNode.hasFocus) {
        _onboardingCubit.onTitleUnfocused();
      }
    });

    _aboutFocusNode.addListener(() {
      if (!_aboutFocusNode.hasFocus) {
        _onboardingCubit.onAboutUnfocused();
      }
    });
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _titleFocusNode.dispose();
    _degreeProgrammeFocusNode.dispose();
    _aboutFocusNode.dispose();

    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _titleController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        headerText("Tell us about yourself"),
        // Profile Photo Picker
        const SizedBox(
          height: 30,
        ),
        PictureUploadPickerWidget(
          onPictureUploadChangedHandler: (image) =>
              _onboardingCubit.onPictureUploadChanged(image),
          image: _onboardingCubit.state.pictureUploadPickerInput.value,
        ),
        const SizedBox(
          height: 30,
        ),
        TextFieldWidget(
          focusNode: _usernameFocusNode,
          controller: _usernameController,
          label: "Username",
          hint: "",
          value: _onboardingCubit.state.usernameInput.value,
          prefixWidget: const Icon(Icons.alternate_email_outlined, size: 20.0),
          suffixWidget: () {
            if (_onboardingCubit.state.onboardingStatus !=
                OnboardingStatus.usernameCheckInProgress) {
              return null;
            }
            return Container(
              padding: const EdgeInsets.all(15.0),
              height: 5,
              width: 5,
              child: const CircularProgressIndicator(
                strokeWidth: 1.5,
                color: blackColor,
              ),
            );
          }(),
          onChangedHandler: (val) {
            print('onchanged username');
            _onboardingCubit.onUsernameChanged(val);
          },
          errorText: _onboardingCubit.state.usernameAsyncError?.text(),
        ),
        TextFieldWidget(
          focusNode: _firstNameFocusNode,
          controller: _firstNameController,
          onChangedHandler: (val) {
            _onboardingCubit.onFirstNameChanged(val);
          },
          label: "First Name",
          value: _onboardingCubit.state.firstNameInput.value,
          hint: "Ex: John",
          errorText: _onboardingCubit.state.firstNameInput.displayError?.text(),
        ),
        TextFieldWidget(
          focusNode: _lastNameFocusNode,
          controller: _lastNameController,
          onChangedHandler: (val) => _onboardingCubit.onLastNameChanged(val),
          label: "Last Name",
          value: _onboardingCubit.state.lastNameInput.value,
          hint: "Ex: Doe",
          errorText: _onboardingCubit.state.lastNameInput.displayError?.text(),
        ),
        TextFieldWidget(
          focusNode: _titleFocusNode,
          controller: _titleController,
          onChangedHandler: (val) => _onboardingCubit.onTitleChanged(val),
          label: "Title",
          value: _onboardingCubit.state.titleInput.value,
          hint: "Ex: Software Developer",
          errorText: _onboardingCubit.state.titleInput.displayError?.text(),
        ),
        DropdownSearchFieldWidget<DegreeProgrammeEntity>(
          focusNode: _degreeProgrammeFocusNode,
          label: "Degree Programme",
          hint: "Select",
          getItems: (String filter) async {
            await _onboardingCubit.handleGetDegreeProgrammes(filter);
            return _onboardingCubit.state.degreeProgrammeOptions;
          },
          selectedItem: _onboardingCubit.state.degreeProgrammeInput.value,
          onChangedHandler: (val) =>
              _onboardingCubit.onDegreeProgrammeChanged(val),
          compareFnHandler: (item1, item2) => item1.id == item2.id,
          errorText:
              _onboardingCubit.state.degreeProgrammeInput.displayError?.text(),
        ),
        headerText("Make an about me"),
        const SizedBox(
          height: 10.0,
        ),
        bodyText(
            "Feel free to share your years of professional experience, industry knowledge, and skills. Additionally, you have the opportunity to share something interesting about yourself!"),
        const SizedBox(height: 10.0),
        TextFieldWidget(
          focusNode: _aboutFocusNode,
          controller: _aboutController,
          onChangedHandler: (val) => _onboardingCubit.onAboutChanged(val),
          label: "",
          value: _onboardingCubit.state.aboutInput.value,
          hint: "",
          size: 10,
        )
      ],
    );
  }
}
