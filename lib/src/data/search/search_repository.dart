import 'package:launchlab/src/domain/search/external_team_entity.dart';
import 'package:launchlab/src/domain/search/responses/get_external_team.dart';
import 'package:launchlab/src/domain/search/responses/get_recomendation.dart';
import 'package:launchlab/src/domain/search/responses/get_search_result.dart';
import 'package:launchlab/src/domain/search/responses/get_user_search_result.dart';
import 'package:launchlab/src/domain/search/search_filter_entity.dart';
import 'package:launchlab/src/domain/search/search_team_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchRepository {
  final supabase = Supabase.instance.client;

  getSearchData(String searchTerm, SearchFilterEntity filterData) async {
    var teamNameData = await supabase
        .from('teams')
        .select('*, roles_open(title)')
        .eq('is_listed', true)
        .textSearch('team_name', searchTerm)
        .filter('commitment', filterData.commitmentInput == '' ? 'neq' : 'eq',
            filterData.commitmentInput)
        .filter(
            'project_category',
            filterData.categoryInput == '' ? 'neq' : 'eq',
            filterData.categoryInput)
        .or(filterData.interestFilterString())
        .limit(8);

    List<SearchTeamEntity> searchedTeams = [];
    for (int i = 0; i < teamNameData.length; i++) {
      var avatarURL = teamNameData[i]['avatar'] == null
          ? ''
          : await supabase.storage
              .from('team_avatar_bucket')
              .createSignedUrl('${teamNameData[i]['avatar']}', 30);
      teamNameData[i]['avatar_url'] = avatarURL;
      searchedTeams.add(SearchTeamEntity.fromJson(teamNameData[i]));
    }

    var teamDescriptionData = await supabase
        .from('teams')
        .select('*, roles_open(title)')
        .eq('is_listed', true)
        .textSearch('description', searchTerm)
        .filter('commitment', filterData.commitmentInput == '' ? 'neq' : 'eq',
            filterData.commitmentInput)
        .filter(
            'project_category',
            filterData.categoryInput == '' ? 'neq' : 'eq',
            filterData.categoryInput)
        .or(filterData.interestFilterString())
        .limit(8);

    for (int i = 0; i < teamDescriptionData.length; i++) {
      var avatarURL = teamDescriptionData[i]['avatar'] == null
          ? ''
          : await supabase.storage
              .from('team_avatar_bucket')
              .createSignedUrl('${teamDescriptionData[i]['avatar']}', 30);
      teamDescriptionData[i]['avatar_url'] = avatarURL;
      searchedTeams.add(SearchTeamEntity.fromJson(teamDescriptionData[i]));
    }

    var user = supabase.auth.currentUser;

    return GetSearchResult(searchedTeams, user!.id);
  }

  getRecomendationData(filterData) async {
    var teamNameData = await supabase
        .from('teams')
        .select('*, roles_open(title)')
        .eq('is_listed', true)
        .filter('commitment', filterData.commitmentInput == '' ? 'neq' : 'eq',
            filterData.commitmentInput)
        .filter(
            'project_category',
            filterData.categoryInput == '' ? 'neq' : 'eq',
            filterData.categoryInput)
        .or(filterData.interestFilterString());

    List<SearchTeamEntity> searchedTeams = [];
    for (int i = 0; i < teamNameData.length; i++) {
      var avatarURL = teamNameData[i]['avatar'] == null
          ? ''
          : await supabase.storage
              .from('team_avatar_bucket')
              .createSignedUrl('${teamNameData[i]['avatar']}', 30);
      teamNameData[i]['avatar_url'] = avatarURL;
      searchedTeams.add(SearchTeamEntity.fromJson(teamNameData[i]));
    }

    var user = supabase.auth.currentUser;
    var preference = await supabase
        .from('preferences')
        .select(
            '*, skills_preferences(selected_skills(name)), categories_preferences(categories(name))')
        .eq('user_id', user?.id)
        .single();

    return GetRecomendationResult(searchedTeams, user!.id, preference);
  }

  getExternalTeamData(teamId) async {
    var teamData = await supabase
        .from('teams')
        .select('*, team_users(user_id), roles_open(title, description)')
        .eq('id', teamId);

    var teamAvatarURL = teamData[0]['avatar'] == null
        ? ''
        : await supabase.storage
            .from('team_avatar_bucket')
            .createSignedUrl('${teamData[0]['avatar']}', 30);
    teamData[0]['avatar_url'] = teamAvatarURL;

    ExternalTeamEntity team = ExternalTeamEntity.fromJson(teamData[0]);

    var ownerDetails = await supabase
        .from('users')
        .select('*, team_users!inner(team_id ,is_owner)')
        .eq('team_users.is_owner', true)
        .eq('team_users.team_id', teamId)
        .single();

    var applicants = await supabase
        .from('team_applicants')
        .select('*')
        .eq('team_id', teamId);

    return GetExternalTeam(team, ownerDetails, applicants);
  }

  getUserSearch(searchUsername) async {
    var userData = await supabase
        .from('users')
        .select(
            '*, degree_programmes(*), experiences(*), accomplishments(*),preferences(*, categories_preferences(categories(*)), skills_preferences(selected_skills(*)))')
        .textSearch('username', searchUsername);
    return GetSearchUserResult(userData);
  }

  applyToTeam({teamId, userId}) async {
    await supabase.from('team_applicants').insert({
      'user_id': userId,
      'team_id': teamId,
      'status': 'pending',
      'applied_at': DateTime.now().toString(),
    });
  }

  reapplyToTeam({teamId, userId}) async {
    await supabase
        .from('team_applicants')
        .update({'status': 'pending', 'applied_at': DateTime.now().toString()})
        .eq('user_id', userId)
        .eq('team_id', teamId);
  }
}
