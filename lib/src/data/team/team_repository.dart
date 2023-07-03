import 'package:launchlab/src/domain/team/responses/get_applicant_data.dart';
import 'package:launchlab/src/domain/team/responses/get_manage_team_data.dart';
import 'package:launchlab/src/domain/team/responses/get_team_data.dart';
import 'package:launchlab/src/domain/team/responses/get_team_home_data.dart';
import 'package:launchlab/src/domain/team/team_entity.dart';
import 'package:launchlab/src/domain/team/team_user_entity.dart';
import 'package:launchlab/src/domain/team/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class TeamRepository {
  final supabase = Supabase.instance.client;

  //Team Home Page

  getTeamHomeData() async {
    final User? user = supabase.auth.currentUser;
    var userData = await supabase.from('users').select().eq('id', user!.id);

    var userAvatarURL = userData[0]['avatar'] == null
        ? ''
        : await supabase.storage
            .from('user_avatar_bucket')
            .createSignedUrl('${userData[0]['avatar']}', 1000);
    userData[0]['avatar_url'] = userAvatarURL;

    var memberTeamData = await supabase
        .from('teams')
        .select('*, team_users!inner(user_id, is_owner) , milestones(*)')
        .eq('team_users.is_owner', false)
        .eq('team_users.user_id', user.id)
        .eq('is_current', true);

    UserEntity userEntity = UserEntity.fromJson(userData[0]);

    List<TeamEntity> memberTeamsEntity = [];

    for (int i = 0; i < memberTeamData.length; i++) {
      var avatarURL = memberTeamData[i]['avatar'] == null
          ? ''
          : await supabase.storage
              .from('team_avatar_bucket')
              .createSignedUrl('${memberTeamData[i]['avatar']}', 1000);
      memberTeamData[i]['avatar_url'] = avatarURL;
      memberTeamsEntity.add(TeamEntity.fromTeamHomeJson(memberTeamData[i]));
    }

    List<TeamEntity> ownerTeamsEntity = [];

    var ownerTeamData = await supabase
        .from('teams')
        .select('*, team_users!inner(user_id, is_owner), milestones(*)')
        .eq('team_users.is_owner', true)
        .eq('team_users.user_id', user.id)
        .eq('is_current', true);

    for (int i = 0; i < ownerTeamData.length; i++) {
      var avatarURL = ownerTeamData[i]['avatar'] == null
          ? ''
          : await supabase.storage
              .from('team_avatar_bucket')
              .createSignedUrl('${ownerTeamData[i]['avatar']}', 1000);
      ownerTeamData[i]['avatar_url'] = avatarURL;
      ownerTeamsEntity.add(TeamEntity.fromTeamHomeJson(ownerTeamData[i]));
    }

    return GetTeamHomeData(memberTeamsEntity, ownerTeamsEntity, userEntity);
  }

  //Team Page

  getTeamData(teamId) async {
    var teamMemberData = await supabase
        .from('team_users')
        .select('*, users(first_name, last_name, avatar)')
        .eq('team_id', teamId);

    List<TeamUserEntity> teamMembers = [];
    for (int i = 0; i < teamMemberData.length; i++) {
      var avatarURL = teamMemberData[i]['users']['avatar'] == null
          ? ''
          : await supabase.storage
              .from('user_avatar_bucket')
              .createSignedUrl('${teamMemberData[i]['users']['avatar']}', 1000);
      teamMemberData[i]['users']['avatar_url'] = avatarURL;
      teamMembers.add(TeamUserEntity.fromJson(teamMemberData[i]));
    }

    //Fix this, do the processing in the get_team data instead.
    var milestone =
        await supabase.from('milestones').select().eq('team_id', teamId);

    var teamData = await supabase.from('teams').select().eq('id', teamId);
    var teamAvatarURL = teamData[0]['avatar'] == null
        ? ''
        : await supabase.storage
            .from('team_avatar_bucket')
            .createSignedUrl('${teamData[0]['avatar']}', 100);

    teamData[0]['avatar_url'] = teamAvatarURL;
    TeamEntity team = TeamEntity.fromJson(teamData[0]);

    return GetTeamData(teamMembers, team, milestone);
  }

  void saveMilestoneData({val, taskId}) async {
    await supabase.from('milestones').update({
      'is_completed': val,
      'updated_at': DateTime.now().toString()
    }).eq('id', taskId);
  }

  void addMilestone({title, startDate, endDate, teamId}) async {
    await supabase.from('milestones').insert({
      'title': title,
      'start_date': startDate,
      'end_date': endDate,
      'team_id': teamId
    });
  }

  void listTeam({teamId, isListed}) async {
    await supabase.from('teams').update({
      'is_listed': isListed,
      'updated_at': DateTime.now().toString()
    }).eq('id', teamId);
  }

  void disbandTeam({teamId}) async {
    await supabase.from('teams').update({
      'is_current': false,
      'is_listed': false,
      'updated_at': DateTime.now().toString()
    }).eq('id', teamId);
  }

  void editMilestone({taskId, title, startDate, endDate}) async {
    await supabase.from('milestones').update({
      'title': title,
      'start_date': startDate,
      'end_date': endDate,
    }).eq('id', taskId);
  }

  void deleteMilestone({taskId}) async {
    await supabase.from('milestones').delete().match({'id': taskId});
  }

  void deleteMember({memberId, teamId, newCurrentMember}) async {
    await supabase
        .from('teams')
        .update({'current_members': newCurrentMember}).eq('id', teamId);
    await supabase.from('team_users').delete().match({'id': memberId});
  }

  //Manage Team Page

  getManageTeamData(teamId) async {
    var applicantUserData = await supabase
        .from('users')
        .select('*, team_applicants!inner(id, team_id)')
        .eq('team_applicants.team_id', teamId);

    List<UserEntity> users = [];
    for (int i = 0; i < applicantUserData.length; i++) {
      var avatarURL = applicantUserData[i]['avatar'] == null
          ? ''
          : await supabase.storage
              .from('user_avatar_bucket')
              .createSignedUrl('${applicantUserData[i]['avatar']}', 60);
      applicantUserData[i]['avatar_url'] = avatarURL;
      users.add(UserEntity.fromManageTeamJson(applicantUserData[i]));
    }

    var rolesData =
        await supabase.from('roles_open').select().eq('team_id', teamId);

    return GetManageTeamData(users, rolesData);
  }

  void addRoles({title, description, teamId}) async {
    await supabase.from('roles_open').insert(
        {'title': title, 'description': description, 'team_id': teamId});
  }

  void updateRoles({title, description, roleId}) async {
    await supabase.from('roles_open').update({
      'title': title,
      'description': description,
      'updated_at': DateTime.now().toString()
    }).eq('id', roleId);
  }

  void deleteRoles({roleId}) async {
    await supabase.from('roles_open').delete().eq('id', roleId);
  }

  //Create & Edit Team Page

  getEditCreateTeamData(teamId) async {
    var teamData = await supabase.from('teams').select().eq('id', teamId);

    var avatarURL = teamData[0]['avatar'] == null
        ? ''
        : await supabase.storage
            .from('team_avatar_bucket')
            .createSignedUrl('${teamData[0]['avatar']}', 30);
    teamData[0]['avatar_url'] = avatarURL;
    TeamEntity team = TeamEntity.fromJson(teamData[0]);

    return team;
  }

  updateTeamData({
    teamId,
    teamName,
    description,
    startDate,
    endDate,
    category,
    commitment,
    maxMember,
    interest,
    avatar,
  }) async {
    await supabase.from('teams').update({
      'team_name': teamName,
      'description': description,
      'start_date': startDate,
      'end_date': endDate == '' ? null : endDate,
      'project_category': category,
      'commitment': commitment,
      'max_members': maxMember,
      'interest': interest,
      'updated_at': DateTime.now().toString()
    }).eq('id', teamId);
  }

  createNewTeam(
      {userId,
      teamName,
      description,
      startDate,
      endDate,
      category,
      commitment,
      maxMember,
      interest,
      avatar}) async {
    var teamId = const Uuid().v4();
    await supabase.from('teams').insert({
      'id': teamId,
      'team_name': teamName,
      'description': description,
      'start_date': startDate,
      'end_date': endDate == '' ? null : endDate,
      'project_category': category,
      'commitment': commitment,
      'current_members': 1,
      'max_members': maxMember,
      'interest': interest,
      'avatar': avatar.toString() == 'null'
          ? null
          : '${teamId}_avatar${avatar.toString().substring(avatar.toString().indexOf('.'))}',
    });

    avatar.toString() == 'null'
        ? print('No Picture Uploaded')
        : await supabase.storage.from('team_avatar_bucket').upload(
            '${teamId}_avatar${avatar.toString().substring(avatar.toString().indexOf('.'))}',
            avatar,
            fileOptions:
                const FileOptions(cacheControl: '3600', upsert: false));

    await supabase.from('team_users').insert({
      'user_id': userId,
      'team_id': teamId,
      'is_owner': true,
      'position': 'Owner'
    });
  }

  //Applicant Page

  getApplicantData(applicationID) async {
    var applicantUserData = await supabase
        .from('users')
        .select('*, team_applicants!inner(id), degree_programmes(name)')
        .eq('team_applicants.id', applicationID);

    var avatarURL = applicantUserData[0]['avatar'] == null
        ? ''
        : await supabase.storage
            .from('user_avatar_bucket')
            .createSignedUrl('${applicantUserData[0]['avatar']}', 60);
    applicantUserData[0]['avatar_url'] = avatarURL;
    UserEntity user = UserEntity.fromApplicantJson(applicantUserData[0]);
    var teamData = await supabase
        .from('teams')
        .select('*, team_applicants!inner(id)')
        .eq('team_applicants.id', applicationID);

    var teamAvatarURL = teamData[0]['avatar'] == null
        ? ''
        : await supabase.storage
            .from('team_avatar_bucket')
            .createSignedUrl('${teamData[0]['avatar']}', 100);
    teamData[0]['avatar_url'] = teamAvatarURL;

    TeamEntity team = TeamEntity.fromJson(teamData[0]);

    var experienceData = await supabase
        .from('experiences')
        .select()
        .eq('user_id', applicantUserData[0]['id'])
        .order('start_date');

    var accomplishmentData = await supabase
        .from('accomplishments')
        .select()
        .eq('user_id', applicantUserData[0]['id'])
        .order('start_date');

    return GetApplicantData(user, team, experienceData, accomplishmentData);
  }

  acceptApplicant({applicationID, currentMember}) async {
    var applicationData =
        await supabase.from('team_applicants').select().eq('id', applicationID);

    await supabase.from('team_users').insert({
      'team_id': applicationData[0]['team_id'],
      'user_id': applicationData[0]['user_id'],
      'position': 'Member',
    });

    await supabase.from('teams').update({
      'current_members': currentMember + 1,
    }).eq('id', applicationData[0]['team_id']);

    await supabase.from('team_applicants').delete().eq('id', applicationID);
  }

  rejectApplicant({applicationID}) async {
    await supabase.from('team_applicants').delete().eq('id', applicationID);
  }
}
