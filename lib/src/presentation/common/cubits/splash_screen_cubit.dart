import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/authentication/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The global state for the whole widget tree
@immutable
class SplashScreenState extends Equatable {
  final Session? session;

  const SplashScreenState({this.session});

  @override
  List<Object?> get props => [session];
}

class SplashScreenCubit extends Cubit<SplashScreenState> {
  final AuthRepository _authRepository;

  SplashScreenCubit(this._authRepository) : super(const SplashScreenState());

  void handleInitAuthSession() async {
    emit(SplashScreenState(
      session: _authRepository.getCurrentAuthSession(),
    ));
  }
}
