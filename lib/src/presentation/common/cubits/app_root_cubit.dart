import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/authentication/repository/auth_repository.dart';

/// The global state for the whole widget tree
@immutable
class AppRootState extends Equatable {
  const AppRootState({
    required this.isSignedIn,
    this.session,
    this.authUserProfile,
    required this.appRootStateStatus,
  });

  final bool isSignedIn;
  final Session? session;
  final UserEntity? authUserProfile;
  final AppRootStateStatus appRootStateStatus;

  AppRootState copyWith({
    bool? isSignedIn,
    Session? session,
    UserEntity? authUserProfile,
    AppRootStateStatus? appRootStateStatus,
  }) {
    return AppRootState(
      isSignedIn: isSignedIn ?? this.isSignedIn,
      session: session ?? this.session,
      authUserProfile: authUserProfile ?? this.authUserProfile,
      appRootStateStatus: appRootStateStatus ?? this.appRootStateStatus,
    );
  }

  @override
  List<Object?> get props => [
        isSignedIn,
        session,
        authUserProfile,
        appRootStateStatus,
      ];
}

enum AppRootStateStatus {
  initial,
  loading,
  success,
  error,
}

class AppRootCubit extends Cubit<AppRootState> {
  final AuthRepository _authRepository;

  AppRootCubit(this._authRepository)
      : super(const AppRootState(
          isSignedIn: false,
          appRootStateStatus: AppRootStateStatus.initial,
        ));

  void handleAuthListener() {
    _authRepository.listenToAuth(
      (data) async {
        final profile = await _authRepository.getAuthUserProfile();
        if (data.event == AuthChangeEvent.signedIn) {
          debugPrint("Signed in");
          emit(state.copyWith(
            isSignedIn: true,
            session: _authRepository.getCurrentAuthSession(),
            authUserProfile: profile,
          ));
        }

        if (data.event == AuthChangeEvent.signedOut) {
          debugPrint("Signed Out");
          emit(state.copyWith(
            isSignedIn: false,
            session: _authRepository.getCurrentAuthSession(),
            authUserProfile: profile,
          ));
        }
      },
    );
  }

  Future<void> handleGetAuthUserProfile() async {
    try {
      emit(state.copyWith(
        appRootStateStatus: AppRootStateStatus.loading,
      ));
      final profile = await _authRepository.getAuthUserProfile();

      emit(state.copyWith(
        authUserProfile: profile,
        appRootStateStatus: AppRootStateStatus.success,
      ));
    } on Exception catch (error) {
      debugPrint('fetch auth profile error: $error');
      emit(state.copyWith(
        appRootStateStatus: AppRootStateStatus.error,
      ));
    }
  }

  void handleStopAuthListener() {
    _authRepository.stopListenToAuth();
  }

  void handleSessionChange({Session? session, UserEntity? authUserProfile}) {
    if (session == null) {
      emit(state.copyWith(
        isSignedIn: false,
        session: session,
        authUserProfile: authUserProfile,
      ));
    } else {
      emit(state.copyWith(
        isSignedIn: true,
        session: session,
        authUserProfile: authUserProfile,
      ));
    }
  }

  Future<void> handleSignOut() async {
    await _authRepository.signOut();
  }
}
