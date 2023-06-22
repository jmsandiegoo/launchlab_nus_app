import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/dropwdown_search_field.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/picture_upload_picker.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/user/cubits/intro_form_cubit.dart';

class IntroForm extends StatefulWidget {
  const IntroForm({super.key});

  @override
  State<IntroForm> createState() => _IntroFormState();
}

class _IntroFormState extends State<IntroForm> {
  late IntroFormCubit _introFormCubit;
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _titleFocusNode = FocusNode();
  final _degreeProgrammeFocusNode = FocusNode();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _introFormCubit = BlocProvider.of<IntroFormCubit>(context);

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
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _titleFocusNode.dispose();
    _degreeProgrammeFocusNode.dispose();

    _firstNameController.dispose();
    _lastNameController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntroFormCubit, IntroFormState>(
      builder: (context, state) => ListView(
        children: [
          headerText("Edit Intro"),
          const SizedBox(
            height: 30,
          ),
          PictureUploadPickerWidget(
            onPictureUploadChangedHandler: (image) =>
                _introFormCubit.onPictureUploadChanged(image),
            image: state.pictureUploadPickerInput.value,
          ),
          const SizedBox(
            height: 30,
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
            getItems: (String filter) async {
              await _introFormCubit.handleGetDegreeProgrammes(filter);
              return state.degreeProgrammeOptions;
            },
            selectedItem: state.degreeProgrammeInput.value,
            onChangedHandler: (val) =>
                _introFormCubit.onDegreeProgrammeChanged(val),
            compareFnHandler: (item1, item2) => item1.id == item2.id,
          ),
        ],
      ),
    );
  }
}
