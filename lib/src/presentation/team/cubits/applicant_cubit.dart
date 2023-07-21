import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/domain/team/responses/get_applicant_data.dart';
import 'package:launchlab/src/domain/team/team_entity.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/failure.dart';

class ApplicantState extends Equatable {
  @override
  List<Object?> get props => [applicationTeamData, actionTypes, status, error];

  final TeamEntity? applicationTeamData;
  final ActionTypes? actionTypes;
  final ApplicantStatus status;
  final Failure? error;

  const ApplicantState(
      {this.applicationTeamData,
      this.actionTypes = ActionTypes.cancel,
      this.status = ApplicantStatus.loading,
      this.error});

  ApplicantState copyWith({
    TeamEntity? applicationTeamData,
    ActionTypes? actionTypes,
    ApplicantStatus? status,
    Failure? error,
  }) {
    return ApplicantState(
      applicationTeamData: applicationTeamData ?? this.applicationTeamData,
      actionTypes: actionTypes ?? this.actionTypes,
      status: status ?? this.status,
      error: error,
    );
  }
}

enum ApplicantStatus {
  loading,
  success,
  error,
}

class ApplicantCubit extends Cubit<ApplicantState> {
  ApplicantCubit(this._teamRepository) : super(const ApplicantState());

  final TeamRepository _teamRepository;

  getData(applicationID) async {
    try {
      final GetApplicantData res =
          await _teamRepository.getApplicantData(applicationID);
      final newState = state.copyWith(
          applicationTeamData: res.team, status: ApplicantStatus.success);

      debugPrint("Applicant State Emitted");
      emit(newState);
    } on Failure catch (error) {
      emit(state.copyWith(status: ApplicantStatus.error, error: error));
    }
  }

  void loading() {
    emit(state.copyWith(status: ApplicantStatus.loading));
  }

  acceptApplicant({applicationID, currentMember}) async {
    debugPrint('Applicant Accepted');
    loading();
    emit(state.copyWith(actionTypes: ActionTypes.update));
    return _teamRepository.acceptApplicant(
        applicationID: applicationID, currentMember: currentMember);
  }

  rejectApplicant({applicationID}) async {
    debugPrint('Applicant Rejected');
    loading();
    emit(state.copyWith(actionTypes: ActionTypes.update));
    return _teamRepository.rejectApplicant(applicationID: applicationID);
  }
}
