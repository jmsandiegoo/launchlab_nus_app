import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/authentication/repository/auth_repository.dart';
import 'package:launchlab/src/utils/failure.dart';

@immutable
class TeamState extends Equatable {
  //final bool isLeading;

  final int currentTask;
  final int totalTask;
  final bool isChecked;

  final Failure? error;

  const TeamState(this.currentTask, this.totalTask, this.isChecked,
      {this.error});

  @override
  List<Object?> get props => [currentTask, totalTask, isChecked, error];
}

class TeamCubit extends Cubit<TeamState> {
  final AuthRepository _authRepository;

  //Get data from DB
  TeamCubit(this._authRepository) : super(const TeamState(7, 10, true));

  Future<void> handleSignOut() async {
    await _authRepository.signOut();
  }

  void setIsCheckedState(bool val) {
    emit(TeamState(7, 10, val));
  }
}
