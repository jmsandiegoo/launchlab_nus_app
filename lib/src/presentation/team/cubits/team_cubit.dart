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

@immutable
class TeamState extends Equatable {
  final List<TeamUserEntity> memberData;
  final List<MilestoneEntity> completedMilestone;
  final List<MilestoneEntity> incompleteMilestone;
  final TeamEntity? teamData;
  final bool isLoaded;

  const TeamState({
    this.memberData = const [],
    this.completedMilestone = const [],
    this.incompleteMilestone = const [],
    this.teamData,
    this.isLoaded = false,
  });

  TeamState copyWith({
    List<TeamUserEntity>? memberData,
    List<MilestoneEntity>? completedMilestone,
    List<MilestoneEntity>? incompleteMilestone,
    TeamEntity? teamData,
    bool? isLoaded,
  }) {
    return TeamState(
      memberData: memberData ?? this.memberData,
      completedMilestone: completedMilestone ?? this.completedMilestone,
      incompleteMilestone: incompleteMilestone ?? this.incompleteMilestone,
      teamData: teamData ?? this.teamData,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }

  @override
  List<Object?> get props =>
      [memberData, completedMilestone, incompleteMilestone, teamData, isLoaded];
}

class TeamCubit extends Cubit<TeamState> {
  final TeamRepository _teamRepository;
  final UserRepository _userRepository;

  TeamCubit(this._teamRepository, this._userRepository)
      : super(const TeamState());

  void getData(String teamId) async {
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
        isLoaded: true);
    debugPrint('Team state emitted');
    emit(newState);
  }

  void loading() {
    emit(state.copyWith(isLoaded: false));
  }

  saveMilestoneData({val, taskId}) async {
    debugPrint('Milestone Saved');
    return _teamRepository.saveMilestoneData(val: val, taskId: taskId);
  }

  void addMilestone({title, startDate, endDate, teamId, description}) {
    _teamRepository.addMilestone(
        title: title,
        startDate: startDate,
        endDate: endDate,
        teamId: teamId,
        description: description);
    debugPrint('Milestone Added');
  }

  void listTeam({teamId, isListed}) {
    _teamRepository.listTeam(teamId: teamId, isListed: isListed);
    debugPrint('Team Listed/Unlisted');
  }

  disbandTeam({teamId}) {
    debugPrint('Team Disbanded');
    return _teamRepository.disbandTeam(teamId: teamId);
  }

  leaveTeam({teamId, newCurrentMember}) {
    debugPrint('Left Team');
    return _teamRepository.leaveTeam(teamId: teamId);
  }

  void editMilestone({taskId, startDate, endDate, title, description}) {
    _teamRepository.editMilestone(
        taskId: taskId,
        startDate: startDate,
        endDate: endDate,
        title: title,
        description: description);
    debugPrint('Task Edited');
  }

  void deleteMilestone({taskId}) {
    _teamRepository.deleteMilestone(taskId: taskId);
    debugPrint('Task Deleted');
  }

  deleteMember({memberId, teamId, newCurrentMember}) {
    debugPrint('Member Removed');
    return _teamRepository.deleteMember(
        memberId: memberId, teamId: teamId, newCurrentMember: newCurrentMember);
  }
}
