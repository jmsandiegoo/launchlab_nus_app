import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/checkbox_field.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/end_date_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/start_date_field.dart';

@immutable
class ExperienceFormState extends Equatable {
  const ExperienceFormState({
    this.titleNameFieldInput = const TextFieldInput.unvalidated(),
    this.companyNameFieldInput = const TextFieldInput.unvalidated(),
    this.isCurrentFieldInput = const CheckboxFieldInput.unvalidated(),
    this.startDateFieldInput = const StartDateFieldInput.unvalidated(),
    this.endDateFieldInput = const EndDateFieldInput.unvalidated(),
    this.descriptionFieldInput = const TextFieldInput.unvalidated(),
    required this.experienceFormStatus,
    required this.experience,
  });

  final TextFieldInput titleNameFieldInput;
  final TextFieldInput companyNameFieldInput;
  final CheckboxFieldInput isCurrentFieldInput;
  final StartDateFieldInput startDateFieldInput;
  final EndDateFieldInput endDateFieldInput;
  final TextFieldInput descriptionFieldInput;
  final ExperienceFormStatus experienceFormStatus;

  final ExperienceEntity experience;

  ExperienceFormState copyWith({
    TextFieldInput? titleNameFieldInput,
    TextFieldInput? companyNameFieldInput,
    CheckboxFieldInput? isCurrentFieldInput,
    StartDateFieldInput? startDateFieldInput,
    EndDateFieldInput? endDateFieldInput,
    TextFieldInput? descriptionFieldInput,
    ExperienceFormStatus? experienceFormStatus,
    ExperienceEntity? experience,
  }) {
    return ExperienceFormState(
      titleNameFieldInput: titleNameFieldInput ?? this.titleNameFieldInput,
      companyNameFieldInput:
          companyNameFieldInput ?? this.companyNameFieldInput,
      isCurrentFieldInput: isCurrentFieldInput ?? this.isCurrentFieldInput,
      startDateFieldInput: startDateFieldInput ?? this.startDateFieldInput,
      endDateFieldInput: endDateFieldInput ?? this.endDateFieldInput,
      descriptionFieldInput:
          descriptionFieldInput ?? this.descriptionFieldInput,
      experienceFormStatus: experienceFormStatus ?? this.experienceFormStatus,
      experience: experience ?? this.experience,
    );
  }

  @override
  List<Object?> get props => [
        titleNameFieldInput,
        companyNameFieldInput,
        isCurrentFieldInput,
        startDateFieldInput,
        endDateFieldInput,
        descriptionFieldInput,
        experienceFormStatus,
        experience,
      ];
}

enum ExperienceFormStatus {
  initial,
  loading,
  createSuccess,
  updateSuccess,
  deleteSuccess,
  error,
}

class ExperienceFormCubit extends Cubit<ExperienceFormState> {
  ExperienceFormCubit()
      : super(
          ExperienceFormState(
            experienceFormStatus: ExperienceFormStatus.initial,
            experience: ExperienceEntity(
              title: '',
              companyName: '',
              isCurrent: false,
              startDate: DateTime.now(),
              description: '',
            ),
          ),
        );
  ExperienceFormCubit.withDefaultValues({required ExperienceEntity experience})
      : super(
          ExperienceFormState(
            titleNameFieldInput: TextFieldInput.unvalidated(experience.title),
            companyNameFieldInput:
                TextFieldInput.unvalidated(experience.companyName),
            isCurrentFieldInput:
                CheckboxFieldInput.unvalidated(experience.isCurrent),
            startDateFieldInput:
                StartDateFieldInput.unvalidated(experience.startDate),
            endDateFieldInput: EndDateFieldInput.unvalidated(
              value: experience.endDate,
            ),
            descriptionFieldInput:
                TextFieldInput.unvalidated(experience.description),
            experienceFormStatus: ExperienceFormStatus.initial,
            experience: experience,
          ),
        );

  void onTitleNameChanged(String val) {
    final prevState = state;
    final prevTitleNameFieldInputState = prevState.titleNameFieldInput;

    final shouldValidate = prevTitleNameFieldInputState.isNotValid;

    final newTitleNameFieldInputState = shouldValidate
        ? TextFieldInput.validated(val)
        : TextFieldInput.unvalidated(val);

    final newState = state.copyWith(
      titleNameFieldInput: newTitleNameFieldInputState,
    );

    emit(newState);
  }

  void onTitleNameUnfocused() {
    final prevState = state;
    final prevTitleNameFieldInputState = prevState.titleNameFieldInput;
    final prevTitleNameFieldInputVal = prevTitleNameFieldInputState.value;

    final newTitleNameFieldInputState =
        TextFieldInput.validated(prevTitleNameFieldInputVal);

    final newState = prevState.copyWith(
      titleNameFieldInput: newTitleNameFieldInputState,
    );

    emit(newState);
  }

  void onCompanyNameChanged(String val) {
    final prevState = state;
    final prevCompanyNameFieldInputState = prevState.companyNameFieldInput;

    final shouldValidate = prevCompanyNameFieldInputState.isNotValid;

    final newCompanyNameFieldInputState = shouldValidate
        ? TextFieldInput.validated(val)
        : TextFieldInput.unvalidated(val);

    final newState = state.copyWith(
      companyNameFieldInput: newCompanyNameFieldInputState,
    );

    emit(newState);
  }

  void onCompanyNameUnfocused() {
    final prevState = state;
    final prevCompanyNameFieldInputState = prevState.companyNameFieldInput;
    final prevCompanyNameFieldInputVal = prevCompanyNameFieldInputState.value;

    final newCompanyNameFieldInputState =
        TextFieldInput.validated(prevCompanyNameFieldInputVal);

    final newState = prevState.copyWith(
      companyNameFieldInput: newCompanyNameFieldInputState,
    );

    emit(newState);
  }

  void onIsCurrentChanged(bool val) {
    final prevState = state;

    final newIsCurrentFieldInputState = CheckboxFieldInput.validated(val);

    final prevEndDateFieldInputState = prevState.endDateFieldInput;

    final newEndDateFieldInputState = EndDateFieldInput.unvalidated(
        isPresent: val, value: val ? null : prevEndDateFieldInputState.value);

    final newState = state.copyWith(
      isCurrentFieldInput: newIsCurrentFieldInputState,
      endDateFieldInput: newEndDateFieldInputState,
    );

    emit(newState);
  }

  void onStartDateChanged(DateTime? val) {
    final prevState = state;

    final newStartDateFieldInputState = StartDateFieldInput.validated(val);

    final newEndDateFieldInputState = EndDateFieldInput.validated(
      isPresent: prevState.isCurrentFieldInput.value,
      startDateFieldVal: val,
      value: prevState.endDateFieldInput.value,
    );

    final newState = state.copyWith(
      startDateFieldInput: newStartDateFieldInputState,
      endDateFieldInput: newEndDateFieldInputState,
    );

    emit(newState);
  }

  void onEndDateChanged(DateTime? val) {
    final newEndDateFieldInputState = EndDateFieldInput.validated(
        isPresent: state.isCurrentFieldInput.value,
        startDateFieldVal: state.startDateFieldInput.value,
        value: val);

    final newState = state.copyWith(
      endDateFieldInput: newEndDateFieldInputState,
    );

    emit(newState);
  }

  void onDescriptionChanged(String val) {
    final prevState = state;
    final prevDescriptionFieldInputState = prevState.descriptionFieldInput;

    final shouldValidate = prevDescriptionFieldInputState.isNotValid;

    final newDescriptionFieldInputState = shouldValidate
        ? TextFieldInput.validated(val)
        : TextFieldInput.unvalidated(val);

    final newState = state.copyWith(
      descriptionFieldInput: newDescriptionFieldInputState,
    );

    emit(newState);
  }

  void onDescriptionUnfocused() {
    final prevState = state;
    final prevDescriptionFieldInputState = prevState.descriptionFieldInput;
    final prevDescriptionFieldInputVal = prevDescriptionFieldInputState.value;

    final newDescriptionFieldInputState =
        TextFieldInput.validated(prevDescriptionFieldInputVal);

    final newState = prevState.copyWith(
      descriptionFieldInput: newDescriptionFieldInputState,
    );

    emit(newState);
  }

  Future<void> handleSubmit(
      {bool isApiCalled = false, bool isEditMode = false}) async {
    final titleNameFieldInput =
        TextFieldInput.validated(state.titleNameFieldInput.value);
    final companyNameFieldInput =
        TextFieldInput.validated(state.companyNameFieldInput.value);
    final CheckboxFieldInput isCurrentFieldInput =
        CheckboxFieldInput.validated(state.isCurrentFieldInput.value);
    final StartDateFieldInput startDateFieldInput =
        StartDateFieldInput.validated(state.startDateFieldInput.value);
    final EndDateFieldInput endDateFieldInput = EndDateFieldInput.validated(
      isPresent: state.isCurrentFieldInput.value,
      startDateFieldVal: state.startDateFieldInput.value,
      value: state.endDateFieldInput.value,
    );
    final TextFieldInput descriptionFieldInput =
        TextFieldInput.validated(state.descriptionFieldInput.value);

    final isFormValid = Formz.validate([
      titleNameFieldInput,
      companyNameFieldInput,
      isCurrentFieldInput,
      startDateFieldInput,
      endDateFieldInput,
      descriptionFieldInput,
    ]);

    if (!isFormValid) {
      emit(state.copyWith(
        titleNameFieldInput: titleNameFieldInput,
        companyNameFieldInput: companyNameFieldInput,
        isCurrentFieldInput: isCurrentFieldInput,
        startDateFieldInput: startDateFieldInput,
        endDateFieldInput: endDateFieldInput,
        descriptionFieldInput: descriptionFieldInput,
      ));
      return;
    }

    if (!isApiCalled) {
      emit(
        state.copyWith(
          experience: state.experience.copyWith(
            title: state.titleNameFieldInput.value,
            companyName: state.companyNameFieldInput.value,
            isCurrent: state.isCurrentFieldInput.value,
            startDate: state.startDateFieldInput.value,
            endDate: state.endDateFieldInput.value,
            description: state.descriptionFieldInput.value,
          ),
          experienceFormStatus: isEditMode
              ? ExperienceFormStatus.updateSuccess
              : ExperienceFormStatus.createSuccess,
        ),
      );
      return;
    } else {
      try {
        emit(
            state.copyWith(experienceFormStatus: ExperienceFormStatus.loading));

        // call api update or esit api accordingly

        emit(state.copyWith(
          experienceFormStatus: isEditMode
              ? ExperienceFormStatus.updateSuccess
              : ExperienceFormStatus.createSuccess,
        ));
      } on Exception catch (_) {
        emit(state.copyWith(
          experienceFormStatus: ExperienceFormStatus.error,
        ));
      }
    }
  }

  Future<void> handleDelete({bool isApiCalled = false}) async {
    if (!isApiCalled) {
      emit(state.copyWith(
          experienceFormStatus: ExperienceFormStatus.deleteSuccess));
      return;
    }
  }
}
