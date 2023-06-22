import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/picture_upload_picker.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/degree_programme_field.dart';

class IntroFormState extends Equatable {
  const IntroFormState({
    this.pictureUploadPickerInput =
        const PictureUploadPickerInput.unvalidated(),
    this.firstNameInput = const TextFieldInput.unvalidated(),
    this.lastNameInput = const TextFieldInput.unvalidated(),
    this.titleInput = const TextFieldInput.unvalidated(),
    this.degreeProgrammeInput = const DegreeProgrammeFieldInput.unvalidated(),
    this.degreeProgrammeOptions = const [],
  });

  final PictureUploadPickerInput pictureUploadPickerInput;
  final TextFieldInput firstNameInput;
  final TextFieldInput lastNameInput;
  final TextFieldInput titleInput;
  final DegreeProgrammeFieldInput degreeProgrammeInput;

  final List<DegreeProgrammeEntity> degreeProgrammeOptions;

  IntroFormState copyWith({
    PictureUploadPickerInput? pictureUploadPickerInput,
    TextFieldInput? firstNameInput,
    TextFieldInput? lastNameInput,
    TextFieldInput? titleInput,
    DegreeProgrammeFieldInput? degreeProgrammeInput,
    List<DegreeProgrammeEntity>? degreeProgrammeOptions,
  }) {
    return IntroFormState(
      pictureUploadPickerInput:
          pictureUploadPickerInput ?? this.pictureUploadPickerInput,
      firstNameInput: firstNameInput ?? this.firstNameInput,
      lastNameInput: lastNameInput ?? this.lastNameInput,
      titleInput: titleInput ?? this.titleInput,
      degreeProgrammeInput: degreeProgrammeInput ?? this.degreeProgrammeInput,
      degreeProgrammeOptions:
          degreeProgrammeOptions ?? this.degreeProgrammeOptions,
    );
  }

  @override
  List<Object?> get props => [
        pictureUploadPickerInput,
        firstNameInput,
        lastNameInput,
        titleInput,
        degreeProgrammeInput,
        degreeProgrammeOptions,
      ];
}

class IntroFormCubit extends Cubit<IntroFormState> {
  IntroFormCubit({
    required this.userRepository,
    required UserEntity userProfile,
    required DegreeProgrammeEntity userDegreeProgramme,
    required File? userAvatarImage,
  }) : super(IntroFormState(
          pictureUploadPickerInput:
              PictureUploadPickerInput.unvalidated(userAvatarImage),
          firstNameInput: TextFieldInput.unvalidated(userProfile.firstName!),
          lastNameInput: TextFieldInput.unvalidated(userProfile.lastName!),
          titleInput: TextFieldInput.unvalidated(userProfile.title!),
          degreeProgrammeInput:
              DegreeProgrammeFieldInput.unvalidated(userDegreeProgramme),
        ));

  final UserRepository userRepository;

  Future<void> handleGetDegreeProgrammes(String? filter) async {
    // call api
    try {
      final List<DegreeProgrammeEntity> degreeProgrammeOptions =
          await userRepository.getDegreeProgrammes(filter);

      emit(state.copyWith(degreeProgrammeOptions: degreeProgrammeOptions));
    } on Exception catch (error) {
      print(error);
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
}
