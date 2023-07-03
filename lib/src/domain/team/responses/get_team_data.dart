import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/team/milestone_entity.dart';

import 'package:launchlab/src/domain/team/team_entity.dart';
import 'package:launchlab/src/domain/team/team_user_entity.dart';

class GetTeamData extends Equatable {
  const GetTeamData(this.teamMembers, this.team, this.milestones);

  final List<TeamUserEntity> teamMembers;
  final TeamEntity team;
  final List milestones;

  @override
  List<Object?> get props => [teamMembers, team, milestones];

  List<MilestoneEntity> getCompletedMilestone() {
    List<MilestoneEntity> completedMilestone = [];
    for (var milestone in milestones) {
      if (milestone['is_completed']) {
        completedMilestone.add(MilestoneEntity.fromJson(milestone));
      }
    }
    return completedMilestone;
  }

  List<MilestoneEntity> getIncompleteMilestone() {
    List<MilestoneEntity> incompleteMilestone = [];
    for (var milestone in milestones) {
      if (milestone['is_completed'] == false) {
        incompleteMilestone.add(MilestoneEntity.fromJson(milestone));
      }
    }
    return incompleteMilestone;
  }
}
