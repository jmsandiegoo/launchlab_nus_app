import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/user/models/requests/update_user_request.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';

class AboutFormState extends Equatable {
  const AboutFormState({
    this.aboutInput = const TextFieldInput.unvalidated(),
    required this.aboutFormStatus,
    required this.userProfile,
  });

  final TextFieldInput aboutInput;
  final AboutFormStatus aboutFormStatus;
  final UserEntity userProfile;

  AboutFormState copyWith({
    TextFieldInput? aboutInput,
    AboutFormStatus? aboutFormStatus,
    UserEntity? userProfile,
  }) {
    return AboutFormState(
      aboutFormStatus: aboutFormStatus ?? this.aboutFormStatus,
      userProfile: userProfile ?? this.userProfile,
      aboutInput: aboutInput ?? this.aboutInput,
    );
  }

  @override
  List<Object?> get props => [
        aboutFormStatus,
        userProfile,
        aboutInput,
      ];
}

enum AboutFormStatus {
  initial,
  success,
  loading,
  error,
}

class AboutFormCubit extends Cubit<AboutFormState> {
  AboutFormCubit({
    required this.userRepository,
    required UserEntity userProfile,
  }) : super(AboutFormState(
          aboutInput: TextFieldInput.unvalidated(
            userProfile.about ?? '',
          ),
          aboutFormStatus: AboutFormStatus.initial,
          userProfile: userProfile,
        ));

  final UserRepository userRepository;

  void onAboutChanged(String val) {
    final prevState = state;
    final prevAboutInputState = prevState.aboutInput;

    final shouldValidate = prevAboutInputState.isNotValid;

    final newAboutInputState = shouldValidate
        ? TextFieldInput.validated(val)
        : TextFieldInput.unvalidated(val);

    final newState = state.copyWith(
      aboutInput: newAboutInputState,
    );

    emit(newState);
  }

  void onAboutUnfocused() {
    final prevState = state;
    final prevAboutInputState = prevState.aboutInput;
    final prevAboutInputVal = prevAboutInputState.value;

    final newAboutInputState = TextFieldInput.validated(prevAboutInputVal);

    final newState = prevState.copyWith(
      aboutInput: newAboutInputState,
    );

    emit(newState);
  }

  Future<void> handleSubmit() async {
    final aboutInput = TextFieldInput.validated(state.aboutInput.value);

    final isFormValid = Formz.validate([
      aboutInput,
    ]);

    if (!isFormValid) {
      emit(state.copyWith(aboutInput: aboutInput));
      return;
    }

    try {
      emit(state.copyWith(aboutFormStatus: AboutFormStatus.loading));
      await userRepository.updateUser(UpdateUserRequest(
        userProfile: state.userProfile.copyWith(about: state.aboutInput.value),
      ));
      emit(state.copyWith(aboutFormStatus: AboutFormStatus.success));
    } on Exception catch (_) {
      emit(state.copyWith(aboutFormStatus: AboutFormStatus.error));
    }
  }
}
