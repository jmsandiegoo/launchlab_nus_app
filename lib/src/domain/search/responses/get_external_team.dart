import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/search/external_team_entity.dart';
import 'package:launchlab/src/domain/search/owner_entity.dart';

class GetExternalTeam extends Equatable {
  const GetExternalTeam(this.teamData, this.ownerData, this.applicantsData);

  final ExternalTeamEntity teamData;
  final OwnerEntity ownerData;
  final List applicantsData;

  @override
  List<Object?> get props => [teamData, ownerData, applicantsData];

  List<String> getCurrentMembers() {
    List<String> currentMembers = [];
    for (var user in teamData.teamUser) {
      currentMembers.add(user['user_id']);
    }
    return currentMembers;
  }

  List<String> getCurrentApplicants() {
    List<String> currentApplicants = [];
    for (var user in applicantsData) {
      if (user['status'] == 'pending') {
        currentApplicants.add(user['user_id']);
      }
    }
    return currentApplicants;
  }

  List<String> getPastApplicants() {
    List<String> pastApplicants = [];
    for (var user in applicantsData) {
      if (user['status'] != 'pending') {
        pastApplicants.add(user['user_id']);
      }
    }
    return pastApplicants;
  }
}
