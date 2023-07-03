import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/domain/team/accomplishment_entity.dart';
import 'package:launchlab/src/domain/team/experience_entity.dart';
import 'package:launchlab/src/domain/team/responses/get_applicant_data.dart';
import 'package:launchlab/src/domain/team/team_entity.dart';
import 'package:launchlab/src/domain/team/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApplicantState extends Equatable {
  @override
  List<Object?> get props => [
        applicantUserData,
        applicationTeamData,
        experienceData,
        accomplishmentData,
        isLoaded
      ];

  final UserEntity? applicantUserData;
  final TeamEntity? applicationTeamData;
  final List<ExperienceTeamEntity> experienceData;
  final List<AccomplishmentTeamEntity> accomplishmentData;
  final bool isLoaded;

  const ApplicantState(
      {this.applicantUserData,
      this.applicationTeamData,
      this.experienceData = const [],
      this.accomplishmentData = const [],
      this.isLoaded = false});

  ApplicantState copyWith({
    UserEntity? applicantUserData,
    TeamEntity? applicationTeamData,
    List<ExperienceTeamEntity>? experienceData,
    List<AccomplishmentTeamEntity>? accomplishmentData,
    bool? isLoaded,
  }) {
    return ApplicantState(
      applicantUserData: applicantUserData ?? this.applicantUserData,
      applicationTeamData: applicationTeamData ?? this.applicationTeamData,
      experienceData: experienceData ?? this.experienceData,
      accomplishmentData: accomplishmentData ?? this.accomplishmentData,
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

  acceptApplicant({applicationID, currentMember}) async {
    _teamRepository.acceptApplicant(
        applicationID: applicationID, currentMember: currentMember);
    debugPrint('Applicant Accepted');
  }

  rejectApplicant({applicationID}) async {
    _teamRepository.rejectApplicant(applicationID: applicationID);
    debugPrint('Applicant Rejected');
  }
}
