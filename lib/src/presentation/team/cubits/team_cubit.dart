import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/domain/team/milestone_entity.dart';
import 'package:launchlab/src/domain/team/responses/get_team_data.dart';
import 'package:launchlab/src/domain/team/team_entity.dart';
import 'package:launchlab/src/domain/team/team_user_entity.dart';

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

  TeamCubit(this._teamRepository) : super(const TeamState());

  void getData(String teamId) async {
    final GetTeamData res = await _teamRepository.getTeamData(teamId);

    final newState = state.copyWith(
        memberData: res.teamMembers,
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

  void addMilestone({title, startDate, endDate, teamId}) {
    _teamRepository.addMilestone(
        title: title, startDate: startDate, endDate: endDate, teamId: teamId);
    debugPrint('Milestone Added');
  }

  void listTeam({teamId, isListed}) {
    _teamRepository.listTeam(teamId: teamId, isListed: isListed);
    debugPrint('Team Listed/Unlisted');
  }

  void disbandTeam({teamId}) {
    _teamRepository.disbandTeam(teamId: teamId);
    debugPrint('Team Disbanded');
  }

  void editMilestone({taskId, startDate, endDate, title}) {
    _teamRepository.editMilestone(
        taskId: taskId, startDate: startDate, endDate: endDate, title: title);
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
