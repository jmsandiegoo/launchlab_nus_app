import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/authentication/repository/auth_repository.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The global state for the whole widget tree
@immutable
class SplashScreenState extends Equatable {
  const SplashScreenState({this.session, this.authUserProfile});

  final Session? session;
  final UserEntity? authUserProfile;

  @override
  List<Object?> get props => [session];
}

class SplashScreenCubit extends Cubit<SplashScreenState> {
  final AuthRepository _authRepository;

  SplashScreenCubit(this._authRepository) : super(const SplashScreenState());

  Future<void> handleInitAuthSession() async {
    final session = _authRepository.getCurrentAuthSession();
    final profile = await _authRepository.getAuthUserProfile();

    emit(SplashScreenState(
      session: session,
      authUserProfile: profile,
    ));
  }
}
