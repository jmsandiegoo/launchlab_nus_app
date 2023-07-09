import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/domain/team/responses/get_applicant_data.dart';
import 'package:launchlab/src/domain/team/team_entity.dart';
import 'package:launchlab/src/domain/team/user_entity.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApplicantState extends Equatable {
  @override
  List<Object?> get props => [
        applicantUserData,
        applicationTeamData,
        experienceData,
        accomplishmentData,
        actionTypes,
        isLoaded
      ];

  final UserEntity? applicantUserData;
  final TeamEntity? applicationTeamData;
  final List<ExperienceEntity> experienceData;
  final List<AccomplishmentEntity> accomplishmentData;
  final ActionTypes? actionTypes;
  final bool isLoaded;

  const ApplicantState(
      {this.applicantUserData,
      this.applicationTeamData,
      this.experienceData = const [],
      this.accomplishmentData = const [],
      this.actionTypes = ActionTypes.cancel,
      this.isLoaded = false});

  ApplicantState copyWith({
    UserEntity? applicantUserData,
    TeamEntity? applicationTeamData,
    List<ExperienceEntity>? experienceData,
    List<AccomplishmentEntity>? accomplishmentData,
    ActionTypes? actionTypes,
    bool? isLoaded,
  }) {
    return ApplicantState(
      applicantUserData: applicantUserData ?? this.applicantUserData,
      applicationTeamData: applicationTeamData ?? this.applicationTeamData,
      experienceData: experienceData ?? this.experienceData,
      accomplishmentData: accomplishmentData ?? this.accomplishmentData,
      actionTypes: actionTypes ?? this.actionTypes,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}

class ApplicantCubit extends Cubit<ApplicantState> {
  ApplicantCubit(this._teamRepository) : super(const ApplicantState());

  final TeamRepository _teamRepository;
  final supabase = Supabase.instance.client;

  getData(applicationID) async {
    final GetApplicantData res =
        await _teamRepository.getApplicantData(applicationID);
    final newState = state.copyWith(
        applicantUserData: res.applicant,
        applicationTeamData: res.team,
        experienceData: res.getAllExperience(),
        accomplishmentData: res.getAllAccomplishment(),
        isLoaded: true);

    debugPrint("Applicant State Emitted");
    emit(newState);
  }

  void loading() {
    emit(state.copyWith(isLoaded: false));
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
