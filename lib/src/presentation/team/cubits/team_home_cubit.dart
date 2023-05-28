import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/authentication/repository/auth_repository.dart';
import 'package:launchlab/src/utils/failure.dart';

@immutable
class TeamHomeState extends Equatable {
  final bool isLeading;
  final Failure? error;

  const TeamHomeState(this.isLeading, {this.error});

  @override
  List<Object?> get props => [isLeading, error];
}

class TeamHomeCubit extends Cubit<TeamHomeState> {
  final AuthRepository _authRepository;

  TeamHomeCubit(this._authRepository) : super(const TeamHomeState(true));

  Future<void> handleSignOut() async {
    await _authRepository.signOut();
  }

  void setIsLeadingState(bool val) {
    emit(TeamHomeState(val));
  }
}
