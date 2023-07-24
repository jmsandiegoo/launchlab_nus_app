import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';
import 'package:launchlab/src/domain/user/models/requests/delete_user_avatar_resume_request.dart';
import 'package:launchlab/src/domain/user/models/requests/update_user_request.dart';
import 'package:launchlab/src/domain/user/models/requests/upload_user_avatar_request.dart';
import 'package:launchlab/src/domain/user/models/user_avatar_entity.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/picture_upload_picker.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/degree_programme_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/username_field.dart';
import 'package:launchlab/src/utils/failure.dart';

class IntroFormState extends Equatable {
  const IntroFormState({
    this.pictureUploadPickerInput =
        const PictureUploadPickerInput.unvalidated(),
    this.firstNameInput = const TextFieldInput.unvalidated(),
    this.usernameInput = const UsernameFieldInput.unvalidated(),
    this.usernameAsyncError,
    this.lastNameInput = const TextFieldInput.unvalidated(),
    this.titleInput = const TextFieldInput.unvalidated(),
    this.degreeProgrammeInput = const DegreeProgrammeFieldInput.unvalidated(),
    this.degreeProgrammeOptions = const [],
    required this.introFormStatus,
    required this.userProfile,
    this.error,
  });

  // inputs
  final PictureUploadPickerInput pictureUploadPickerInput;
  final UsernameFieldInput usernameInput;
  final UsernameFieldError? usernameAsyncError;
  final TextFieldInput firstNameInput;
  final TextFieldInput lastNameInput;
  final TextFieldInput titleInput;
  final DegreeProgrammeFieldInput degreeProgrammeInput;

  // others
  final UserEntity userProfile;
  final List<DegreeProgrammeEntity> degreeProgrammeOptions;
  final IntroFormStatus introFormStatus;
  final Failure? error;

  IntroFormState copyWith({
    PictureUploadPickerInput? pictureUploadPickerInput,
    UsernameFieldInput? usernameInput,
    UsernameFieldError? usernameAsyncError,
    bool isForceUsernameErrorNull = false,
    TextFieldInput? firstNameInput,
    TextFieldInput? lastNameInput,
    TextFieldInput? titleInput,
    DegreeProgrammeFieldInput? degreeProgrammeInput,
    List<DegreeProgrammeEntity>? degreeProgrammeOptions,
    IntroFormStatus? introFormStatus,
    UserEntity? userProfile,
    Failure? error,
  }) {
    return IntroFormState(
      pictureUploadPickerInput:
          pictureUploadPickerInput ?? this.pictureUploadPickerInput,
      usernameInput: usernameInput ?? this.usernameInput,
      usernameAsyncError: isForceUsernameErrorNull
          ? usernameAsyncError
          : (usernameAsyncError ?? this.usernameAsyncError),
      firstNameInput: firstNameInput ?? this.firstNameInput,
      lastNameInput: lastNameInput ?? this.lastNameInput,
      titleInput: titleInput ?? this.titleInput,
      degreeProgrammeInput: degreeProgrammeInput ?? this.degreeProgrammeInput,
      degreeProgrammeOptions:
          degreeProgrammeOptions ?? this.degreeProgrammeOptions,
      introFormStatus: introFormStatus ?? this.introFormStatus,
      userProfile: userProfile ?? this.userProfile,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        pictureUploadPickerInput,
        usernameInput,
        usernameAsyncError,
        firstNameInput,
        lastNameInput,
        titleInput,
        degreeProgrammeInput,
        degreeProgrammeOptions,
        introFormStatus,
        userProfile,
        error,
      ];
}

enum IntroFormStatus {
  initial,
  idle,
  success,
  usernameCheckLoading,
  loading,
  error,
}

class IntroFormCubit extends Cubit<IntroFormState> {
  IntroFormCubit({
    required this.userRepository,
    required UserEntity userProfile,
    required DegreeProgrammeEntity userDegreeProgramme,
    required UserAvatarEntity? userAvatar,
  }) : super(IntroFormState(
          pictureUploadPickerInput:
              PictureUploadPickerInput.unvalidated(userAvatar?.file),
          usernameInput: UsernameFieldInput.unvalidated(userProfile.username),
          firstNameInput: TextFieldInput.unvalidated(userProfile.firstName!),
          lastNameInput: TextFieldInput.unvalidated(userProfile.lastName!),
          titleInput: TextFieldInput.unvalidated(userProfile.title!),
          degreeProgrammeInput:
              DegreeProgrammeFieldInput.unvalidated(userDegreeProgramme),
          introFormStatus: IntroFormStatus.initial,
          userProfile: userProfile,
          error: null,
        ));

  final UserRepository userRepository;

  Future<void> handleGetDegreeProgrammes(String? filter) async {
    // call api
    try {
      final List<DegreeProgrammeEntity> degreeProgrammeOptions =
          await userRepository.getDegreeProgrammes(filter);

      emit(state.copyWith(degreeProgrammeOptions: degreeProgrammeOptions));
    } on Exception catch (_) {
      rethrow;
    }
  }

  void onPictureUploadChanged(File? image) {
    final prevState = state;
    final prevPictureUploadPickerInputState =
        prevState.pictureUploadPickerInput;

    final shouldValidate = prevPictureUploadPickerInputState.isNotValid;

    final newPictureUploadPickerInputState = shouldValidate
        ? PictureUploadPickerInput.validated(image)
        : PictureUploadPickerInput.unvalidated(image);

    final newState = state.copyWith(
      pictureUploadPickerInput: newPictureUploadPickerInputState,
    );

    emit(newState);
  }

  void onUsernameChanged(String val) {
    final prevState = state;
    final prevUsernameInputState = prevState.usernameInput;

    final shouldValidate = prevUsernameInputState.isNotValid;

    final newUsernameInputState = shouldValidate
        ? UsernameFieldInput.validated(val)
        : UsernameFieldInput.unvalidated(val);

    final newState = state.copyWith(
      usernameInput: newUsernameInputState,
      introFormStatus: IntroFormStatus.idle,
      usernameAsyncError: newUsernameInputState.displayError,
      isForceUsernameErrorNull: true,
    );

    emit(newState);
  }

  // onUsernameUnfocused
  Future<void> onUsernameUnfocused() async {
    final prevState = state;
    final prevUsernameInputState = prevState.usernameInput;
    final prevUsernameInputVal = prevUsernameInputState.value;

    emit(state.copyWith(introFormStatus: IntroFormStatus.usernameCheckLoading));

    final error = await prevUsernameInputState.validatorAsync(
      state.userProfile.username,
      userRepository,
    );

    final newUsernameInputState =
        UsernameFieldInput.validated(prevUsernameInputVal);
    final newState = state.copyWith(
      usernameInput: newUsernameInputState,
      introFormStatus: IntroFormStatus.idle,
      usernameAsyncError: error,
      isForceUsernameErrorNull: true,
    );

    emit(newState);
  }

  void onFirstNameChanged(String val) {
    final prevState = state;
    final prevFirstNameInputState = prevState.firstNameInput;

    final shouldValidate = prevFirstNameInputState.isNotValid;

    final newFirstNameInputState = shouldValidate
        ? TextFieldInput.validated(val)
        : TextFieldInput.unvalidated(val);

    final newState = state.copyWith(
      firstNameInput: newFirstNameInputState,
    );

    emit(newState);
  }

  void onFirstNameUnfocused() {
    final prevState = state;
    final prevFirstNameInputState = prevState.firstNameInput;
    final prevFirstNameInputVal = prevFirstNameInputState.value;

    final newFirstNameInputState =
        TextFieldInput.validated(prevFirstNameInputVal);

    final newState = prevState.copyWith(
      firstNameInput: newFirstNameInputState,
    );

    emit(newState);
  }

  void onLastNameChanged(String val) {
    final prevState = state;
    final prevLastNameInputState = prevState.lastNameInput;

    final shouldValidate = prevLastNameInputState.isNotValid;

    final newLastNameInputState = shouldValidate
        ? TextFieldInput.validated(val)
        : TextFieldInput.unvalidated(val);

    final newState = state.copyWith(
      lastNameInput: newLastNameInputState,
    );

    emit(newState);
  }

  void onLastNameUnfocused() {
    final prevState = state;
    final prevLastNameInputState = prevState.lastNameInput;
    final prevLastNameInputVal = prevLastNameInputState.value;

    final newLastNameInputState =
        TextFieldInput.validated(prevLastNameInputVal);

    final newState = prevState.copyWith(
      lastNameInput: newLastNameInputState,
    );
    emit(newState);
  }

  void onTitleChanged(String val) {
    final prevState = state;
    final prevTitleInputState = prevState.titleInput;

    final shouldValidate = prevTitleInputState.isNotValid;

    final newTitleInputState = shouldValidate
        ? TextFieldInput.validated(val)
        : TextFieldInput.unvalidated(val);

    final newState = state.copyWith(
      titleInput: newTitleInputState,
    );

    emit(newState);
  }

  void onTitleUnfocused() {
    final prevState = state;
    final prevTitleInputState = prevState.titleInput;
    final prevTitleInputVal = prevTitleInputState.value;

    final newTitleInputState = TextFieldInput.validated(prevTitleInputVal);

    final newState = prevState.copyWith(
      titleInput: newTitleInputState,
    );

    emit(newState);
  }

  void onDegreeProgrammeChanged(DegreeProgrammeEntity? val) {
    final prevState = state;
    final prevDegreeProgrammeInputState = prevState.degreeProgrammeInput;

    final shouldValidate = prevDegreeProgrammeInputState.isNotValid;

    final newDegreeProgrammeInputState = shouldValidate
        ? DegreeProgrammeFieldInput.validated(val)
        : DegreeProgrammeFieldInput.unvalidated(val);

    final newState = state.copyWith(
      degreeProgrammeInput: newDegreeProgrammeInputState,
    );

    emit(newState);
  }

  Future<void> handleSubmit() async {
    final pictureUploadPickerInput = PictureUploadPickerInput.validated(
        state.pictureUploadPickerInput.value);
    final firstNameInput = TextFieldInput.validated(state.firstNameInput.value);
    final lastNameInput = TextFieldInput.validated(state.lastNameInput.value);
    final titleInput = TextFieldInput.validated(state.titleInput.value);
    final degreeProgrammeInput =
        DegreeProgrammeFieldInput.validated(state.degreeProgrammeInput.value);

    emit(state.copyWith(introFormStatus: IntroFormStatus.loading));

    // check username async validation again
    final error = await state.usernameInput.validatorAsync(
      state.userProfile.username,
      userRepository,
    );

    final isFormValid = Formz.validate([
      pictureUploadPickerInput,
      firstNameInput,
      lastNameInput,
      titleInput,
      degreeProgrammeInput,
    ]);

    if (!isFormValid || error != null) {
      emit(state.copyWith(
        pictureUploadPickerInput: pictureUploadPickerInput,
        firstNameInput: firstNameInput,
        lastNameInput: lastNameInput,
        titleInput: titleInput,
        degreeProgrammeInput: degreeProgrammeInput,
        usernameAsyncError: error,
        isForceUsernameErrorNull: true,
        introFormStatus: IntroFormStatus.idle,
      ));
      return;
    }

    try {
      if (state.pictureUploadPickerInput.value != null) {
        await userRepository.uploadUserAvatar(UploadUserAvatarRequest(
            userAvatar: UserAvatarEntity(
                userId: state.userProfile.id!,
                file: state.pictureUploadPickerInput.value!)));
      } else {
        await userRepository.deleteUserAvatar(
            DeleteUserAvatarResumeRequest(userId: state.userProfile.id!));
      }

      await userRepository.updateUser(UpdateUserRequest(
        userProfile: state.userProfile.copyWith(
          username: state.usernameInput.value,
          firstName: state.firstNameInput.value,
          lastName: state.lastNameInput.value,
          title: state.titleInput.value,
          degreeProgrammeId: state.degreeProgrammeInput.value!.id,
        ),
      ));

      emit(state.copyWith(
        introFormStatus: IntroFormStatus.success,
        error: null,
      ));
    } on Failure catch (error) {
      emit(
          state.copyWith(introFormStatus: IntroFormStatus.error, error: error));
    }
  }
}
