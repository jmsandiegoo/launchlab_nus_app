import 'package:launchlab/src/domain/search/responses/get_external_team.dart';
import 'package:launchlab/src/domain/search/responses/get_recomendation.dart';
import 'package:launchlab/src/domain/search/responses/get_search_result.dart';
import 'package:launchlab/src/domain/search/search_filter_entity.dart';

import '../responses/get_user_search_result.dart';

/// Search Repository Interface

abstract class SearchRepositoryImpl {
  Future<GetSearchResult> getSearchData(
      String searchTerm, SearchFilterEntity filterData);

  Future<GetRecomendationResult> getRecomendationData(
      SearchFilterEntity filterData);

  Future<GetExternalTeam> getExternalTeamData(String teamId);

  Future<GetSearchUserResult> getUserSearch(String searchUsername);

  void applyToTeam({required String teamId, required String userId});

  void reapplyToTeam({required String teamId, required String userId});
}
