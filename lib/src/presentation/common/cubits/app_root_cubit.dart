import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/authentication/repository/auth_repository.dart';

/// The global state for the whole widget tree
@immutable
class AppRootState extends Equatable {
  final bool isSignedIn;
  final Session? session;

  const AppRootState(this.isSignedIn, {this.session});

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
          emit(AppRootState(true,
              session: _authRepository.getCurrentAuthSession()));
        }

        if (data.event == AuthChangeEvent.signedOut) {
          emit(AppRootState(false,
              session: _authRepository.getCurrentAuthSession()));
        }
      },
    );
  }

  void handleStopAuthListener() {
    _authRepository.stopListenToAuth();
  }

  void handleSessionChange(Session? session) {
    if (session == null) {
      emit(AppRootState(false, session: session));
    } else {
      emit(AppRootState(true, session: session));
    }
  }
}
