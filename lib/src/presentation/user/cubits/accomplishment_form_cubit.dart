import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/domain/user/models/requests/create_user_accomplishment_request.dart';
import 'package:launchlab/src/domain/user/models/requests/delete_user_accomplishment_request.dart';
import 'package:launchlab/src/domain/user/models/requests/update_user_accomplishment_request.dart';
import 'package:launchlab/src/domain/user/models/responses/create_user_accomplishment_response.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/checkbox_field.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/end_date_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/start_date_field.dart';
import 'package:launchlab/src/utils/failure.dart';

@immutable
class AccomplishmentFormState extends Equatable {
  const AccomplishmentFormState({
    this.titleNameFieldInput = const TextFieldInput.unvalidated(),
    this.issuerFieldInput = const TextFieldInput.unvalidated(),
    this.isActiveFieldInput = const CheckboxFieldInput.unvalidated(),
    this.startDateFieldInput = const StartDateFieldInput.unvalidated(),
    this.endDateFieldInput = const EndDateFieldInput.unvalidated(),
    this.descriptionFieldInput = const TextFieldInput.unvalidated(),
    required this.accomplishmentFormStatus,
    required this.accomplishment,
    this.error,
  });

  final TextFieldInput titleNameFieldInput;
  final TextFieldInput issuerFieldInput;
  final CheckboxFieldInput isActiveFieldInput;
  final StartDateFieldInput startDateFieldInput;
  final EndDateFieldInput endDateFieldInput;
  final TextFieldInput descriptionFieldInput;
  final AccomplishmentFormStatus accomplishmentFormStatus;
  final Failure? error;

  final AccomplishmentEntity accomplishment;

  AccomplishmentFormState copyWith({
    TextFieldInput? titleNameFieldInput,
    TextFieldInput? issuerFieldInput,
    CheckboxFieldInput? isActiveFieldInput,
    StartDateFieldInput? startDateFieldInput,
    EndDateFieldInput? endDateFieldInput,
    TextFieldInput? descriptionFieldInput,
    AccomplishmentFormStatus? accomplishmentFormStatus,
    Failure? error,
    AccomplishmentEntity? accomplishment,
  }) {
    return AccomplishmentFormState(
      titleNameFieldInput: titleNameFieldInput ?? this.titleNameFieldInput,
      issuerFieldInput: issuerFieldInput ?? this.issuerFieldInput,
      isActiveFieldInput: isActiveFieldInput ?? this.isActiveFieldInput,
      startDateFieldInput: startDateFieldInput ?? this.startDateFieldInput,
      endDateFieldInput: endDateFieldInput ?? this.endDateFieldInput,
      descriptionFieldInput:
          descriptionFieldInput ?? this.descriptionFieldInput,
      accomplishmentFormStatus:
          accomplishmentFormStatus ?? this.accomplishmentFormStatus,
      error: error,
      accomplishment: accomplishment ?? this.accomplishment,
    );
  }

  @override
  List<Object?> get props => [
        titleNameFieldInput,
        issuerFieldInput,
        isActiveFieldInput,
        startDateFieldInput,
        endDateFieldInput,
        descriptionFieldInput,
        accomplishmentFormStatus,
        accomplishment,
        error,
      ];
}

enum AccomplishmentFormStatus {
  initial,
  createLoading,
  updateLoading,
  deleteLoading,
  createSuccess,
  updateSuccess,
  deleteSuccess,
  error,
}

class AccomplishmentFormCubit extends Cubit<AccomplishmentFormState> {
  AccomplishmentFormCubit({required this.userRepository})
      : super(
          AccomplishmentFormState(
            accomplishmentFormStatus: AccomplishmentFormStatus.initial,
            accomplishment: AccomplishmentEntity(
              title: '',
              issuer: '',
              isActive: false,
              startDate: DateTime.now(),
              description: '',
            ),
          ),
        );
  AccomplishmentFormCubit.withDefaultValues(
      {required this.userRepository,
      required AccomplishmentEntity accomplishment})
      : super(
          AccomplishmentFormState(
            titleNameFieldInput:
                TextFieldInput.unvalidated(accomplishment.title),
            issuerFieldInput: TextFieldInput.unvalidated(accomplishment.issuer),
            isActiveFieldInput:
                CheckboxFieldInput.unvalidated(accomplishment.isActive),
            startDateFieldInput:
                StartDateFieldInput.unvalidated(accomplishment.startDate),
            endDateFieldInput:
                EndDateFieldInput.unvalidated(value: accomplishment.endDate),
            descriptionFieldInput: accomplishment.description != null
                ? TextFieldInput.unvalidated(accomplishment.description!)
                : const TextFieldInput.unvalidated(),
            accomplishmentFormStatus: AccomplishmentFormStatus.initial,
            accomplishment: accomplishment,
          ),
        );

  final UserRepository userRepository;

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

  void onIssuerChanged(String val) {
    final prevState = state;
    final prevIssuerFieldInputState = prevState.issuerFieldInput;

    final shouldValidate = prevIssuerFieldInputState.isNotValid;

    final newIssuerFieldInputState = shouldValidate
        ? TextFieldInput.validated(val)
        : TextFieldInput.unvalidated(val);

    final newState = state.copyWith(
      issuerFieldInput: newIssuerFieldInputState,
    );

    emit(newState);
  }

  void onIssuerUnfocused() {
    final prevState = state;
    final prevIssuerFieldInputState = prevState.issuerFieldInput;
    final prevIssuerFieldInputVal = prevIssuerFieldInputState.value;

    final newIssuerFieldInputState =
        TextFieldInput.validated(prevIssuerFieldInputVal);

    final newState = prevState.copyWith(
      issuerFieldInput: newIssuerFieldInputState,
    );

    emit(newState);
  }

  void onIsActiveChanged(bool val) {
    final prevState = state;

    final newIsActiveFieldInputState = CheckboxFieldInput.validated(val);

    final prevEndDateFieldInputState = prevState.endDateFieldInput;

    final newEndDateFieldInputState = EndDateFieldInput.unvalidated(
        isPresent: val, value: val ? null : prevEndDateFieldInputState.value);

    final newState = state.copyWith(
      isActiveFieldInput: newIsActiveFieldInputState,
      endDateFieldInput: newEndDateFieldInputState,
    );

    emit(newState);
  }

  void onStartDateChanged(DateTime? val) {
    final prevState = state;

    final newStartDateFieldInputState = StartDateFieldInput.validated(val);

    final newEndDateFieldInputState = EndDateFieldInput.validated(
      isPresent: prevState.isActiveFieldInput.value,
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
        isPresent: state.isActiveFieldInput.value,
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

  bool validateForm() {
    final titleNameFieldInput =
        TextFieldInput.validated(state.titleNameFieldInput.value);
    final issuerFieldInput =
        TextFieldInput.validated(state.issuerFieldInput.value);
    final CheckboxFieldInput isActiveFieldInput =
        CheckboxFieldInput.validated(state.isActiveFieldInput.value);
    final StartDateFieldInput startDateFieldInput =
        StartDateFieldInput.validated(state.startDateFieldInput.value);
    final EndDateFieldInput endDateFieldInput = EndDateFieldInput.validated(
      isPresent: state.isActiveFieldInput.value,
      startDateFieldVal: state.startDateFieldInput.value,
      value: state.endDateFieldInput.value,
    );
    final TextFieldInput descriptionFieldInput =
        TextFieldInput.validated(state.descriptionFieldInput.value);

    final isFormValid = Formz.validate([
      titleNameFieldInput,
      issuerFieldInput,
      isActiveFieldInput,
      startDateFieldInput,
      endDateFieldInput,
      descriptionFieldInput,
    ]);

    emit(state.copyWith(
      titleNameFieldInput: titleNameFieldInput,
      issuerFieldInput: issuerFieldInput,
      isActiveFieldInput: isActiveFieldInput,
      endDateFieldInput: endDateFieldInput,
      descriptionFieldInput: descriptionFieldInput,
    ));

    return isFormValid;
  }

  Future<void> handleSubmit({
    bool isApiCalled = false,
    bool isEditMode = false,
    String createUserId = '',
  }) async {
    if (state.accomplishmentFormStatus ==
            AccomplishmentFormStatus.createLoading ||
        state.accomplishmentFormStatus ==
            AccomplishmentFormStatus.updateLoading ||
        state.accomplishmentFormStatus ==
            AccomplishmentFormStatus.deleteLoading) {
      return;
    }

    final titleNameFieldInput =
        TextFieldInput.validated(state.titleNameFieldInput.value);
    final issuerFieldInput =
        TextFieldInput.validated(state.issuerFieldInput.value);
    final CheckboxFieldInput isActiveFieldInput =
        CheckboxFieldInput.validated(state.isActiveFieldInput.value);
    final StartDateFieldInput startDateFieldInput =
        StartDateFieldInput.validated(state.startDateFieldInput.value);
    final EndDateFieldInput endDateFieldInput = EndDateFieldInput.validated(
      isPresent: state.isActiveFieldInput.value,
      startDateFieldVal: state.startDateFieldInput.value,
      value: state.endDateFieldInput.value,
    );
    final TextFieldInput descriptionFieldInput =
        TextFieldInput.validated(state.descriptionFieldInput.value);

    final isFormValid = Formz.validate([
      titleNameFieldInput,
      issuerFieldInput,
      isActiveFieldInput,
      startDateFieldInput,
      endDateFieldInput,
      descriptionFieldInput,
    ]);

    if (!isFormValid) {
      emit(state.copyWith(
        titleNameFieldInput: titleNameFieldInput,
        issuerFieldInput: issuerFieldInput,
        isActiveFieldInput: isActiveFieldInput,
        startDateFieldInput: startDateFieldInput,
        endDateFieldInput: endDateFieldInput,
        descriptionFieldInput: descriptionFieldInput,
      ));
      return;
    }

    if (!isApiCalled) {
      emit(
        state.copyWith(
          accomplishment: state.accomplishment.copyWith(
            title: state.titleNameFieldInput.value,
            issuer: state.issuerFieldInput.value,
            isActive: state.isActiveFieldInput.value,
            startDate: state.startDateFieldInput.value,
            endDate: state.endDateFieldInput.value,
            description: state.descriptionFieldInput.value,
          ),
          accomplishmentFormStatus: isEditMode
              ? AccomplishmentFormStatus.updateSuccess
              : AccomplishmentFormStatus.createSuccess,
        ),
      );
      return;
    } else {
      try {
        AccomplishmentEntity accomplishment = state.accomplishment.copyWith(
          title: state.titleNameFieldInput.value,
          issuer: state.issuerFieldInput.value,
          isActive: state.isActiveFieldInput.value,
          startDate: state.startDateFieldInput.value,
          endDate: state.endDateFieldInput.value,
          description: state.descriptionFieldInput.value,
        );

        if (isEditMode) {
          emit(state.copyWith(
              accomplishmentFormStatus:
                  AccomplishmentFormStatus.updateLoading));
          await userRepository
              .updateUserAccomplishment(UpdateUserAccomplishmentRequest(
                  accomplishment: accomplishment.copyWith(
            endDate: accomplishment.endDate,
            createdAt: accomplishment.createdAt ?? DateTime.now().toUtc(),
            updatedAt: DateTime.now().toUtc(),
          )));
        } else {
          emit(state.copyWith(
              accomplishmentFormStatus:
                  AccomplishmentFormStatus.createLoading));
          CreateUserAccomplishmentResponse res = await userRepository
              .createUserAccomplishment(CreateUserAccomplishmentRequest(
                  accomplishment: accomplishment.copyWith(
            userId: createUserId,
            endDate: accomplishment.endDate,
            createdAt: DateTime.now().toUtc(),
            updatedAt: DateTime.now().toUtc(),
          )));
          accomplishment = res.accomplishment;
        }

        emit(state.copyWith(
          accomplishment: accomplishment,
          accomplishmentFormStatus: isEditMode
              ? AccomplishmentFormStatus.updateSuccess
              : AccomplishmentFormStatus.createSuccess,
        ));
      } on Failure catch (error) {
        emit(
          state.copyWith(
              accomplishmentFormStatus: AccomplishmentFormStatus.error,
              error: error),
        );
      }
    }
  }

  Future<void> handleDelete({bool isApiCalled = false}) async {
    if (!isApiCalled) {
      emit(state.copyWith(
          accomplishmentFormStatus: AccomplishmentFormStatus.deleteSuccess));
      return;
    }

    try {
      emit(state.copyWith(
          accomplishmentFormStatus: AccomplishmentFormStatus.deleteLoading));
      await userRepository.deleteUserAccomplishment(
          DeleteUserAccomplishmentRequest(
              accomplishment: state.accomplishment));
      emit(state.copyWith(
        accomplishmentFormStatus: AccomplishmentFormStatus.deleteSuccess,
      ));
    } on Failure catch (error) {
      emit(
        state.copyWith(
            accomplishmentFormStatus: AccomplishmentFormStatus.error,
            error: error),
      );
    }
  }
}
