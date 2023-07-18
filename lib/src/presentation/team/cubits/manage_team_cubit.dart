import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/team/responses/get_manage_team_data.dart';
import 'package:launchlab/src/domain/team/role_entity.dart';
import 'package:launchlab/src/domain/team/team_applicant_entity.dart';
import 'package:launchlab/src/domain/user/models/requests/download_avatar_image_request.dart';
import 'package:launchlab/src/domain/user/models/requests/download_user_resume_request.dart';
import 'package:launchlab/src/domain/user/models/user_avatar_entity.dart';
import 'package:launchlab/src/domain/user/models/user_resume_entity.dart';
import 'package:launchlab/src/utils/failure.dart';

@immutable
class ManageTeamState extends Equatable {
  final List<TeamApplicantEntity> applicantUserData;
  final List<RoleEntity> rolesData;
  final ManageTeamStatus status;
  final Failure? error;

  @override
  List<Object?> get props => [applicantUserData, rolesData, status, error];

  const ManageTeamState(
      {this.applicantUserData = const [],
      this.rolesData = const [],
      this.status = ManageTeamStatus.loading,
      this.error});

  ManageTeamState copyWith({
    List<TeamApplicantEntity>? applicantUserData,
    List<RoleEntity>? rolesData,
    ManageTeamStatus? status,
    Failure? error,
  }) {
    return ManageTeamState(
      applicantUserData: applicantUserData ?? this.applicantUserData,
      rolesData: rolesData ?? this.rolesData,
      status: status ?? this.status,
      error: error,
    );
  }
}

enum ManageTeamStatus {
  loading,
  success,
  error,
}

class ManageTeamCubit extends Cubit<ManageTeamState> {
  final TeamRepository _teamRepository;
  final UserRepository _userRepository;

  ManageTeamCubit(this._teamRepository, this._userRepository)
      : super(const ManageTeamState());

  void getData(teamId) async {
    try {
      final GetManageTeamData res =
          await _teamRepository.getManageTeamData(teamId);

      List<TeamApplicantEntity> applicants = res.getAllApplicant();

      List<Future<UserAvatarEntity?>> asyncOperations = [];
      List<Future<UserResumeEntity?>> asyncOperationsResume = [];

      for (int i = 0; i < applicants.length; i++) {
        asyncOperations.add(_userRepository.fetchUserAvatar(
            DownloadAvatarImageRequest(
                userId: applicants[i].user.id!, isSignedUrlEnabled: true)));
        asyncOperationsResume.add(_userRepository.fetchUserResume(
            DownloadUserResumeRequest(userId: applicants[i].user.id!)));
      }
      List<UserAvatarEntity?> avatars = await Future.wait(asyncOperations);
      List<UserResumeEntity?> resumes =
          await Future.wait(asyncOperationsResume);

      for (int i = 0; i < applicants.length; i++) {
        applicants[i] = applicants[i].copyWith(
            user: applicants[i].user.copyWith(
                userAvatar: avatars[i],
                userResume: resumes[i],
                userDegreeProgramme: applicants[i].user.userDegreeProgramme,
                userPreference: applicants[i].user.userPreference,
                userAccomplishments: applicants[i].user.userAccomplishments,
                userExperiences: applicants[i].user.userExperiences));
      }

      final newState = state.copyWith(
          applicantUserData: applicants,
          rolesData: res.getAllRoles(),
          status: ManageTeamStatus.success);
      debugPrint("Manage Team State Emitted");
      emit(newState);
    } on Failure catch (error) {
      emit(state.copyWith(status: ManageTeamStatus.error, error: error));
    }
  }

  void loading() {
    emit(state.copyWith(status: ManageTeamStatus.loading));
  }

  void addRoles({title, description, teamId}) {
    _teamRepository.addRoles(
        title: title, description: description, teamId: teamId);
    debugPrint("Role Added");
  }

  void updateRoles({title, description, roleId}) {
    _teamRepository.updateRoles(
        title: title, description: description, roleId: roleId);
    debugPrint("Role Updated");
  }

  void deleteRoles({roleId}) async {
    _teamRepository.deleteRoles(roleId: roleId);
    debugPrint("Role Deleted");
  }
}
