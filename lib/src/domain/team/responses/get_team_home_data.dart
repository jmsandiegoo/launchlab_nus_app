import 'package:equatable/equatable.dart';

import 'package:launchlab/src/domain/team/team_entity.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';

class GetTeamHomeData extends Equatable {
  const GetTeamHomeData(this.memberTeams, this.ownerTeams, this.user);

  final List<TeamEntity> memberTeams;
  final List<TeamEntity> ownerTeams;
  final UserEntity user;

  @override
  List<Object?> get props => [memberTeams, ownerTeams, user];
}
