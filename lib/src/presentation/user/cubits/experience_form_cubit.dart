import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  });

  final TextFieldInput titleNameFieldInput;
  final TextFieldInput companyNameFieldInput;
  final CheckboxFieldInput isCurrentFieldInput;
  final StartDateFieldInput startDateFieldInput;
  final EndDateFieldInput endDateFieldInput;
  final TextFieldInput descriptionFieldInput;

  ExperienceFormState copyWith({
    TextFieldInput? titleNameFieldInput,
    TextFieldInput? companyNameFieldInput,
    CheckboxFieldInput? isCurrentFieldInput,
    StartDateFieldInput? startDateFieldInput,
    EndDateFieldInput? endDateFieldInput,
    TextFieldInput? descriptionFieldInput,
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
      ];
}

class ExperienceFormCubit extends Cubit<ExperienceFormState> {
  ExperienceFormCubit() : super(const ExperienceFormState());
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
}
