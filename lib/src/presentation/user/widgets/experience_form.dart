import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/buttons/ll_outlined_button.dart';
import 'package:launchlab/src/presentation/common/widgets/feedback_toast.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/date_picker.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/common/widgets/text/ll_body_text.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/user/cubits/experience_form_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/end_date_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/start_date_field.dart';
import 'package:launchlab/src/utils/toast_manager.dart';

class ExperienceForm<T extends Cubit> extends StatefulWidget {
  const ExperienceForm({
    super.key,
    required this.isEditMode,
    required this.onSubmitHandler,
    this.onDeleteHandler,
  });

  final bool isEditMode;
  final void Function(BuildContext context, ExperienceFormState)
      onSubmitHandler;
  final void Function(BuildContext context, ExperienceFormState)?
      onDeleteHandler;

  @override
  State<ExperienceForm> createState() => _ExperienceFormState();
}

class _ExperienceFormState extends State<ExperienceForm> {
  late ExperienceFormCubit _experienceFormCubit;

  final _titleNameFocusNode = FocusNode();
  final _companyNameFocusNode = FocusNode();
  final _startDateFocusNode = FocusNode();
  final _endDateFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  final _titleNameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _experienceFormCubit = BlocProvider.of<ExperienceFormCubit>(context);

    _titleNameFocusNode.addListener(() {
      if (!_titleNameFocusNode.hasFocus) {
        _experienceFormCubit.onTitleNameUnfocused();
      }
    });

    _companyNameFocusNode.addListener(() {
      if (!_companyNameFocusNode.hasFocus) {
        _experienceFormCubit.onCompanyNameUnfocused();
      }
    });

    _descriptionFocusNode.addListener(() {
      if (_descriptionFocusNode.hasFocus) {
        _experienceFormCubit.onDescriptionUnfocused();
      }
    });
  }

  @override
  void dispose() {
    _titleNameFocusNode.dispose();
    _companyNameFocusNode.dispose();
    _startDateFocusNode.dispose();
    _endDateFocusNode.dispose();
    _descriptionFocusNode.dispose();

    _titleNameController.dispose();
    _companyNameController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExperienceFormCubit, ExperienceFormState>(
        listener: (context, state) {
      if (state.experienceFormStatus == ExperienceFormStatus.error &&
          state.error != null) {
        ToastManager()
            .showFToast(child: ErrorFeedback(msg: state.error!.errorMessage));
      }
    }, listenWhen: (previous, current) {
      return previous.experienceFormStatus != current.experienceFormStatus;
    }, builder: (context, state) {
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
                        "${widget.isEditMode ? "Edit" : "Add"} Experience"),
                    LLBodyText(label: widget.isEditMode
                        ? "Modify your work experience below."
                        : "Specify your work experience below so to display it on your profile."),
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
            focusNode: _titleNameFocusNode,
            controller: _titleNameController,
            onChangedHandler: (value) =>
                _experienceFormCubit.onTitleNameChanged(value),
            label: "Title Name",
            value: state.titleNameFieldInput.value,
            hint: "Ex: Frontend Developer",
            errorText: state.titleNameFieldInput.displayError?.text(),
          ),
          TextFieldWidget(
            focusNode: _companyNameFocusNode,
            controller: _companyNameController,
            onChangedHandler: (value) =>
                _experienceFormCubit.onCompanyNameChanged(value),
            label: "Company Name",
            value: state.companyNameFieldInput.value,
            hint: "Ex: Google",
            errorText: state.companyNameFieldInput.displayError?.text(),
          ),
          checkBox(
              "I currently work here",
              state.isCurrentFieldInput.value,
              false,
              (value) => _experienceFormCubit.onIsCurrentChanged(value!)),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Expanded(
                child: DatePickerWidget(
                  controller: _startDateController,
                  focusNode: _startDateFocusNode,
                  label: "Start Date",
                  hint: '',
                  errorText: state.startDateFieldInput.displayError?.text(),
                  onChangedHandler: (value) =>
                      _experienceFormCubit.onStartDateChanged(value),
                  initialDate: state.startDateFieldInput.value,
                ),
              ),
              Container(
                height: 30,
                padding: const EdgeInsets.symmetric(
                  horizontal: 5.0,
                ),
                child: const Text("—"),
              ),
              Expanded(
                child: state.isCurrentFieldInput.value
                    ? const SizedBox(
                        height: 30,
                        child: LLBodyText(label: "Present", fontWeight: FontWeight.w600),
                      )
                    : DatePickerWidget(
                        isEnabled: state.startDateFieldInput.value != null,
                        controller: _endDateController,
                        focusNode: _endDateFocusNode,
                        label: "End Date",
                        hint: '',
                        errorText: state.endDateFieldInput.displayError?.text(),
                        onChangedHandler: (value) =>
                            _experienceFormCubit.onEndDateChanged(value),
                        initialDate: state.endDateFieldInput.value,
                      ),
              ),
            ],
          ),
          TextFieldWidget(
            focusNode: _descriptionFocusNode,
            controller: _descriptionController,
            onChangedHandler: (value) =>
                _experienceFormCubit.onDescriptionChanged(value),
            label: "Description",
            value: state.descriptionFieldInput.value,
            hint: "Ex: Write something about the team etc.",
            errorText: state.descriptionFieldInput.displayError?.text(),
            minLines: 9,
            maxLines: 9,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              primaryButton(
                  context,
                  () => widget.onSubmitHandler(context, state),
                  widget.isEditMode ? "Edit" : "Create",
                  elevation: 0,
                  isLoading: state.experienceFormStatus ==
                          ExperienceFormStatus.createLoading ||
                      state.experienceFormStatus ==
                          ExperienceFormStatus.updateLoading),
              ...() {
                return widget.isEditMode
                    ? [
                        LLOutlinedButton(
                          label: "Delete",
                          onPressedHandler: () =>
                              widget.onDeleteHandler!(context, state),
                          color: errorColor,
                          isLoading: state.experienceFormStatus ==
                              ExperienceFormStatus.deleteLoading,
                        ),
                      ]
                    : [];
              }()
            ],
          )
        ],
      );
    });
  }
}
