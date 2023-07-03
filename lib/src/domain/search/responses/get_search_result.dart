import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/search/search_team_entity.dart';

class GetSearchResult extends Equatable {
  const GetSearchResult(this.searchedTeam, this.userId);

  final List<SearchTeamEntity> searchedTeam;
  final String userId;

  @override
  List<Object?> get props => [searchedTeam, userId];

  List<SearchTeamEntity> uniqueSearchedTeams() {
    List<SearchTeamEntity> shownTeams = [];
    for (var team in searchedTeam) {
      if (!shownTeams.contains(team)) {
        shownTeams.add(team);
      }
    }
    return shownTeams;
  }
}
