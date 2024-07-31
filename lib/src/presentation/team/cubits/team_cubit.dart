import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/team/milestone_entity.dart';
import 'package:launchlab/src/domain/team/responses/get_team_data.dart';
import 'package:launchlab/src/domain/team/team_entity.dart';
import 'package:launchlab/src/domain/team/team_user_entity.dart';
import 'package:launchlab/src/domain/user/models/requests/download_avatar_image_request.dart';
import 'package:launchlab/src/domain/user/models/user_avatar_entity.dart';
import 'package:launchlab/src/utils/failure.dart';

@immutable
class TeamState extends Equatable {
  final List<TeamUserEntity> memberData;
  final List<MilestoneEntity> completedMilestone;
  final List<MilestoneEntity> incompleteMilestone;
  final TeamEntity? teamData;
  final TeamStatus status;
  final Failure? error;

  const TeamState(
      {this.memberData = const [],
      this.completedMilestone = const [],
      this.incompleteMilestone = const [],
      this.teamData,
      this.status = TeamStatus.loading,
      this.error});

  TeamState copyWith({
    List<TeamUserEntity>? memberData,
    List<MilestoneEntity>? completedMilestone,
    List<MilestoneEntity>? incompleteMilestone,
    TeamEntity? teamData,
    TeamStatus? status,
    Failure? error,
  }) {
    return TeamState(
      memberData: memberData ?? this.memberData,
      completedMilestone: completedMilestone ?? this.completedMilestone,
      incompleteMilestone: incompleteMilestone ?? this.incompleteMilestone,
      teamData: teamData ?? this.teamData,
      status: status ?? this.status,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        memberData,
        completedMilestone,
        incompleteMilestone,
        teamData,
        status,
        error
      ];
}

enum TeamStatus {
  loading,
  success,
  error,
}

class TeamCubit extends Cubit<TeamState> {
  final TeamRepository _teamRepository;
  final UserRepository _userRepository;

  TeamCubit(this._teamRepository, this._userRepository)
      : super(const TeamState());

  void getData(String teamId) async {
    try {
      final GetTeamData res = await _teamRepository.getTeamData(teamId);
      List<TeamUserEntity> teamMembers = [...res.teamMembers];

      List<Future<UserAvatarEntity?>> asyncOperations = [];

      for (int i = 0; i < teamMembers.length; i++) {
        final TeamUserEntity member = teamMembers[i];
        asyncOperations.add(_userRepository.fetchUserAvatar(
            DownloadAvatarImageRequest(
                userId: member.userId, isSignedUrlEnabled: true)));
      }

      List<UserAvatarEntity?> avatars = await Future.wait(asyncOperations);

      for (int i = 0; i < teamMembers.length; i++) {
        final TeamUserEntity member = teamMembers[i];
        teamMembers[i] =
            member.copyWith(user: member.user.copyWith(userAvatar: avatars[i]));
      }

      final newState = state.copyWith(
          memberData: teamMembers,
          completedMilestone: res.getCompletedMilestone(),
          incompleteMilestone: res.getIncompleteMilestone(),
          teamData: res.team,
          status: TeamStatus.success);
          
      emit(newState);
    } on Failure catch (error) {
      emit(state.copyWith(status: TeamStatus.error, error: error));
    }
  }

  void loading() {
    emit(state.copyWith(status: TeamStatus.loading));
  }

  saveMilestoneData({required bool val, required String taskId}) async {
    debugPrint('Milestone Saved');
    return _teamRepository.saveMilestoneData(val: val, taskId: taskId);
  }

  void addMilestone(
      {required String title,
      required String startDate,
      required String endDate,
      required String teamId,
      required String description}) {
    _teamRepository.addMilestone(
        title: title,
        startDate: startDate,
        endDate: endDate,
        teamId: teamId,
        description: description);
    debugPrint('Milestone Added');
  }

  void listTeam({required String teamId, required bool isListed}) {
    _teamRepository.listTeam(teamId: teamId, isListed: isListed);
    debugPrint('Team Listed/Unlisted');
  }

  disbandTeam({required String teamId}) {
    debugPrint('Team Disbanded');
    return _teamRepository.disbandTeam(teamId: teamId);
  }

  leaveTeam({required String teamId}) {
    debugPrint('Left Team');
    return _teamRepository.leaveTeam(teamId: teamId);
  }

  void editMilestone(
      {required String taskId,
      required String startDate,
      required String endDate,
      required String title,
      required String description}) {
    _teamRepository.editMilestone(
        taskId: taskId,
        startDate: startDate,
        endDate: endDate,
        title: title,
        description: description);
    debugPrint('Task Edited');
  }

  void deleteMilestone({required String taskId}) {
    _teamRepository.deleteMilestone(taskId: taskId);
    debugPrint('Task Deleted');
  }

  deleteMember(
      {required String memberId,
      required String teamId,
      required int newCurrentMember}) {
    debugPrint('Member Removed');
    return _teamRepository.deleteMember(
        memberId: memberId, teamId: teamId, newCurrentMember: newCurrentMember);
  }
}
