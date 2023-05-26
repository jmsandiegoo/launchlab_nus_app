import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/authentication/repository/auth_repository.dart';

/// The global state for the whole widget tree
@immutable
class AppRootState extends Equatable {
  final bool isSignedIn;

  const AppRootState(this.isSignedIn);

  @override
  List<Object?> get props => [isSignedIn];
}

class AppRootCubit extends Cubit<AppRootState> {
  final AuthRepository _authRepository;

  AppRootCubit(this._authRepository) : super(const AppRootState(false));

  void handleAuthListener() {
    _authRepository.listenToAuth(
      (data) {
        if (data.event == AuthChangeEvent.signedIn) {
          print("Singedin");
          emit(const AppRootState(true));
        }

        if (data.event == AuthChangeEvent.signedOut) {
          print("Signedout");
          emit(const AppRootState(false));
        }
      },
    );
  }
}
