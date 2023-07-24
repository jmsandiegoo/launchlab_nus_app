import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/authentication/repository/auth_repository.dart';
import '../../../utils/failure.dart';

/// Global appstate used for shared states throughout the application
@immutable
class SigninState extends Equatable {
  final Failure? error;

  const SigninState({this.error});

  @override
  List<Object?> get props => [error];
}

class SigninLoading extends SigninState {
  const SigninLoading();
}

class SigninFailure extends SigninState {
  const SigninFailure(Failure error);
}

/// Cubit / Controller
class SigninCubit extends Cubit<SigninState> {
  final AuthRepository _authRepository;

  SigninCubit(this._authRepository) : super(const SigninState());

  Future<void> handleSigninWithGoogle() async {
    emit(const SigninLoading());
    try {
      await _authRepository.signinWithGoogle();
      emit(const SigninState());
    } on Failure catch (error) {
      emit(SigninState(error: error));
    }
  }
}
