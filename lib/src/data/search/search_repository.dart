import 'package:launchlab/src/domain/search/external_team_entity.dart';
import 'package:launchlab/src/domain/search/owner_entity.dart';
import 'package:launchlab/src/domain/search/responses/get_external_team.dart';
import 'package:launchlab/src/domain/search/responses/get_search_result.dart';
import 'package:launchlab/src/domain/search/search_team_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchRepository {
  final supabase = Supabase.instance.client;

  getSearchData(String searchTerm) async {
    var teamNameData = await supabase
        .from('teams')
        .select('*, roles_open(title)')
        .eq('is_listed', true)
        .textSearch('team_name', searchTerm)
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
        .select(
            'first_name, last_name, avatar, team_users!inner(team_id ,is_owner)')
        .eq('team_users.is_owner', true)
        .eq('team_users.team_id', teamId);

    var teamOwnerURL = ownerDetails[0]['avatar'] == null
        ? ''
        : await supabase.storage
            .from('user_avatar_bucket')
            .createSignedUrl('${ownerDetails[0]['avatar']}', 30);
    ownerDetails[0]['avatar_url'] = teamOwnerURL;

    OwnerEntity owner = OwnerEntity.fromJson(ownerDetails[0]);

    var applicants = await supabase
        .from('team_applicants')
        .select('user_id')
        .eq('team_id', teamId);

    return GetExternalTeam(team, owner, applicants);
  }

  applyToTeam({teamId, userId}) async {
    await supabase.from('team_applicants').insert({
      'user_id': userId,
      'team_id': teamId,
      'applied_at': DateTime.now().toString(),
    });
  }
}
