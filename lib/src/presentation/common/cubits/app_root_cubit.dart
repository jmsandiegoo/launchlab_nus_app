import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/authentication/repository/auth_repository.dart';

/// The global state for the whole widget tree
@immutable
class AppRootState extends Equatable {
  const AppRootState(
    this.isSignedIn, {
    this.session,
    this.authUserProfile,
  });

  final bool isSignedIn;
  final Session? session;
  final UserEntity? authUserProfile;

  @override
  List<Object?> get props => [
        isSignedIn,
        session,
        authUserProfile,
      ];
}

class AppRootCubit extends Cubit<AppRootState> {
  final AuthRepository _authRepository;

  AppRootCubit(this._authRepository) : super(const AppRootState(false));

  void handleAuthListener() {
    _authRepository.listenToAuth(
      (data) async {
        final profile = await _authRepository.getAuthUserProfile();
        if (data.event == AuthChangeEvent.signedIn) {
          print("Signed in");
          emit(AppRootState(
            true,
            session: _authRepository.getCurrentAuthSession(),
            authUserProfile: profile,
          ));
        }

        if (data.event == AuthChangeEvent.signedOut) {
          print("Signed Out");
          emit(AppRootState(
            false,
            session: _authRepository.getCurrentAuthSession(),
            authUserProfile: profile,
          ));
        }
      },
    );
  }

  void handleStopAuthListener() {
    _authRepository.stopListenToAuth();
  }

  void handleSessionChange({Session? session, UserEntity? authUserProfile}) {
    if (session == null) {
      emit(AppRootState(
        false,
        session: session,
        authUserProfile: authUserProfile,
      ));
    } else {
      emit(AppRootState(
        true,
        session: session,
        authUserProfile: authUserProfile,
      ));
    }
  }
}
