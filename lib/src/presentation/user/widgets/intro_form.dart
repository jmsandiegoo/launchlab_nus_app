import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/feedback_toast.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/dropwdown_search_field.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/picture_upload_picker.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/username_field.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/user/cubits/intro_form_cubit.dart';
import 'package:launchlab/src/utils/toast_manager.dart';

class IntroForm extends StatefulWidget {
  const IntroForm({super.key});

  @override
  State<IntroForm> createState() => _IntroFormState();
}

class _IntroFormState extends State<IntroForm> {
  late IntroFormCubit _introFormCubit;
  final _usernameFocusNode = FocusNode();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _titleFocusNode = FocusNode();
  final _degreeProgrammeFocusNode = FocusNode();

  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _introFormCubit = BlocProvider.of<IntroFormCubit>(context);

    _usernameFocusNode.addListener(() {
      if (!_usernameFocusNode.hasFocus) {
        _introFormCubit.onUsernameUnfocused();
      }
    });

    _firstNameFocusNode.addListener(() {
      if (!_firstNameFocusNode.hasFocus) {
        _introFormCubit.onFirstNameUnfocused();
      }
    });

    _lastNameFocusNode.addListener(() {
      if (!_lastNameFocusNode.hasFocus) {
        _introFormCubit.onLastNameUnfocused();
      }
    });

    _titleFocusNode.addListener(() {
      if (!_titleFocusNode.hasFocus) {
        _introFormCubit.onTitleUnfocused();
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

    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IntroFormCubit, IntroFormState>(
      listener: (context, state) {
        if (state.introFormStatus == IntroFormStatus.success) {
          ToastManager().showFToast(
              child: const SuccessFeedback(msg: "Edit intro successful!"));
        }

        if (state.introFormStatus == IntroFormStatus.error &&
            state.error != null) {
          ToastManager()
              .showFToast(child: ErrorFeedback(msg: state.error!.errorMessage));
        }
      },
      listenWhen: (previous, current) {
        return previous.introFormStatus != current.introFormStatus;
      },
      builder: (context, state) => ListView(
        children: [
          headerText("Edit Intro"),
          const SizedBox(
            height: 30,
          ),
          Align(
            alignment: Alignment.center,
            child: PictureUploadPickerWidget(
              onPictureUploadChangedHandler: (image) =>
                  _introFormCubit.onPictureUploadChanged(image),
              image: state.pictureUploadPickerInput.value,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          TextFieldWidget(
            focusNode: _usernameFocusNode,
            controller: _usernameController,
            label: "Username",
            hint: "",
            value: state.usernameInput.value,
            prefixWidget:
                const Icon(Icons.alternate_email_outlined, size: 20.0),
            suffixWidget: () {
              if (state.introFormStatus !=
                  IntroFormStatus.usernameCheckLoading) {
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
              debugPrint('onchanged username');
              _introFormCubit.onUsernameChanged(val);
            },
            errorText: state.usernameAsyncError?.text(),
          ),
          TextFieldWidget(
            focusNode: _firstNameFocusNode,
            controller: _firstNameController,
            onChangedHandler: (val) {
              _introFormCubit.onFirstNameChanged(val);
            },
            label: "First Name",
            value: state.firstNameInput.value,
            hint: "Ex: John",
            errorText: state.firstNameInput.displayError?.text(),
          ),
          TextFieldWidget(
            focusNode: _lastNameFocusNode,
            controller: _lastNameController,
            onChangedHandler: (val) => _introFormCubit.onLastNameChanged(val),
            label: "Last Name",
            value: state.lastNameInput.value,
            hint: "Ex: Doe",
            errorText: state.lastNameInput.displayError?.text(),
          ),
          TextFieldWidget(
            focusNode: _titleFocusNode,
            controller: _titleController,
            onChangedHandler: (val) => _introFormCubit.onTitleChanged(val),
            label: "Title",
            value: state.titleInput.value,
            hint: "Ex: Software Developer",
            errorText: state.titleInput.displayError?.text(),
          ),
          DropdownSearchFieldWidget<DegreeProgrammeEntity>(
            focusNode: _degreeProgrammeFocusNode,
            label: "Degree Programme",
            hint: "Select",
            isFilterOnline: true,
            getItems: (String filter) async {
              await _introFormCubit.handleGetDegreeProgrammes(filter);
              return _introFormCubit.state.degreeProgrammeOptions;
            },
            selectedItem: state.degreeProgrammeInput.value,
            onChangedHandler: (val) =>
                _introFormCubit.onDegreeProgrammeChanged(val),
            compareFnHandler: (item1, item2) => item1.id == item2.id,
          ),
          primaryButton(
            context,
            () {
              _introFormCubit.handleSubmit();
            },
            "Save",
            elevation: 0,
            isLoading: state.introFormStatus == IntroFormStatus.loading,
          ),
        ],
      ),
    );
  }
}
