import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/search/search_team_entity.dart';

class GetRecomendationResult extends Equatable {
  const GetRecomendationResult(this.searchedTeam, this.userId, this.preference);

  final List<SearchTeamEntity> searchedTeam;
  final String userId;
  final Map preference;

  @override
  List<Object?> get props => [searchedTeam, userId];

  List<SearchTeamEntity> getRecomendedTeams() {
    List rankingList = [];
    for (SearchTeamEntity team in searchedTeam) {
      int score = 0;
      for (String interest in userInterestPrefenence()) {
        if (team.interestName.contains(interest)) {
          score += 1;
        }
      }

      if (userCategoryPreference().contains(team.category)) {
        score += 1;
      }
      rankingList.add([score, team]);
    }

    //Sorting the teams based on ranks
    rankingList.sort((a, b) => b[0].compareTo(a[0]));
    List<SearchTeamEntity> recommendedTeam =
        rankingList.map((e) => e[1] as SearchTeamEntity).toList();

    return recommendedTeam;
  }

  List<String> userInterestPrefenence() {
    List<String> userInterest = [];
    for (var skill in preference['skills_preferences']) {
      userInterest.add(skill['selected_skills']['name']);
    }
    return userInterest;
  }

  List<String> userCategoryPreference() {
    List<String> userCategory = [];
    for (var category in preference['categories_preferences']) {
      userCategory.add(category['categories']['name']);
    }
    return userCategory;
  }
}
