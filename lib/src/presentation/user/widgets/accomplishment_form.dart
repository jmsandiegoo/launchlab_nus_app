import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/feedback_toast.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/date_picker.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/user/cubits/accomplishment_form_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/end_date_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/start_date_field.dart';
import 'package:launchlab/src/utils/toast_manager.dart';

class AccomplishmentForm extends StatefulWidget {
  const AccomplishmentForm({
    super.key,
    required this.isEditMode,
    required this.onSubmitHandler,
    this.onDeleteHandler,
  });

  final bool isEditMode;
  final void Function(BuildContext, AccomplishmentFormState) onSubmitHandler;
  final void Function(BuildContext, AccomplishmentFormState)? onDeleteHandler;

  @override
  State<AccomplishmentForm> createState() => _AccomplishmentFormState();
}

class _AccomplishmentFormState extends State<AccomplishmentForm> {
  late AccomplishmentFormCubit _accomplishmentFormCubit;

  final _titleNameFocusNode = FocusNode();
  final _issuerFocusNode = FocusNode();
  final _startDateFocusNode = FocusNode();
  final _endDateFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  final _titleNameController = TextEditingController();
  final _issuerController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _accomplishmentFormCubit =
        BlocProvider.of<AccomplishmentFormCubit>(context);

    _titleNameFocusNode.addListener(() {
      if (!_titleNameFocusNode.hasFocus) {
        _accomplishmentFormCubit.onTitleNameUnfocused();
      }
    });

    _issuerFocusNode.addListener(() {
      if (!_issuerFocusNode.hasFocus) {
        _accomplishmentFormCubit.onIssuerUnfocused();
      }
    });

    _descriptionFocusNode.addListener(() {
      if (_descriptionFocusNode.hasFocus) {
        _accomplishmentFormCubit.onDescriptionUnfocused();
      }
    });
  }

  @override
  void dispose() {
    _titleNameFocusNode.dispose();
    _issuerFocusNode.dispose();
    _startDateFocusNode.dispose();
    _endDateFocusNode.dispose();
    _descriptionFocusNode.dispose();

    _titleNameController.dispose();
    _issuerController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccomplishmentFormCubit, AccomplishmentFormState>(
      listener: (context, state) {
        if (state.accomplishmentFormStatus == AccomplishmentFormStatus.error &&
            state.error != null) {
          ToastManager().showFToast(
              child: ErrorFeedback(
            msg: state.error!.errorMessage,
          ));
        }
      },
      listenWhen: (previous, current) {
        return previous.accomplishmentFormStatus !=
            current.accomplishmentFormStatus;
      },
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
              focusNode: _titleNameFocusNode,
              controller: _titleNameController,
              onChangedHandler: (value) =>
                  _accomplishmentFormCubit.onTitleNameChanged(value),
              label: "Title Name",
              value: state.titleNameFieldInput.value,
              hint: "Ex: Best in CS1231S award",
              errorText: state.titleNameFieldInput.displayError?.text(),
            ),
            TextFieldWidget(
              focusNode: _issuerFocusNode,
              controller: _issuerController,
              onChangedHandler: (value) =>
                  _accomplishmentFormCubit.onIssuerChanged(value),
              label: "Issuer",
              value: state.issuerFieldInput.value,
              hint: "Ex: National University of Singapore",
              errorText: state.issuerFieldInput.displayError?.text(),
            ),
            checkBox(
              "Still Active",
              state.isActiveFieldInput.value,
              false,
              (value) => _accomplishmentFormCubit.onIsActiveChanged(value!),
            ),
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
                    onChangedHandler: (value) =>
                        _accomplishmentFormCubit.onStartDateChanged(value),
                    initialDate: state.startDateFieldInput.value,
                    errorText: state.startDateFieldInput.displayError?.text(),
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
                  child: state.isActiveFieldInput.value
                      ? SizedBox(
                          height: 30,
                          child: bodyText(" Present", weight: FontWeight.w600),
                        )
                      : DatePickerWidget(
                          isEnabled: state.startDateFieldInput.value != null,
                          controller: _endDateController,
                          focusNode: FocusNode(),
                          label: "End Date",
                          hint: '',
                          onChangedHandler: (value) =>
                              _accomplishmentFormCubit.onEndDateChanged(value),
                          initialDate: state.endDateFieldInput.value,
                          errorText:
                              state.endDateFieldInput.displayError?.text(),
                        ),
                ),
              ],
            ),
            TextFieldWidget(
              focusNode: _descriptionFocusNode,
              controller: _descriptionController,
              onChangedHandler: (value) =>
                  _accomplishmentFormCubit.onDescriptionChanged(value),
              label: "Description",
              value: state.descriptionFieldInput.value,
              hint: "Ex: Write something about the accomplishment etc.",
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
                    isLoading: state.accomplishmentFormStatus ==
                            AccomplishmentFormStatus.createLoading ||
                        state.accomplishmentFormStatus ==
                            AccomplishmentFormStatus.updateLoading),
                ...() {
                  return widget.isEditMode
                      ? [
                          outlinedButton(
                            label: "Delete",
                            onPressedHandler: () =>
                                widget.onDeleteHandler!(context, state),
                            color: errorColor,
                            isLoading: state.accomplishmentFormStatus ==
                                AccomplishmentFormStatus.deleteLoading,
                          ),
                        ]
                      : [];
                }()
              ],
            )
          ],
        );
      }),
    );
  }
}
