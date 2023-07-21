import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:launchlab/src/domain/common/models/skill_entity.dart';
import 'package:launchlab/src/domain/team/repository/team_repository_impl.dart';
import 'package:launchlab/src/domain/team/responses/get_applicant_data.dart';
import 'package:launchlab/src/domain/team/responses/get_manage_team_data.dart';
import 'package:launchlab/src/domain/team/responses/get_team_data.dart';
import 'package:launchlab/src/domain/team/responses/get_team_home_data.dart';
import 'package:launchlab/src/domain/team/team_entity.dart';
import 'package:launchlab/src/domain/team/team_user_entity.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/utils/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class TeamRepository implements TeamRepositoryImpl {
  final supabase = Supabase.instance.client;

  /// real-time
  @override
  RealtimeChannel subscribeToTeamUsers(
      {required String teamId,
      required FutureOr<void> Function(dynamic payload) streamHandler}) {
    final RealtimeChannel channel =
        supabase.channel('public:team_users_${DateTime.now()}').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
          event: '*',
          schema: 'public',
          table: 'team_users',
          filter: 'team_id=eq.$teamId'),
      (payload, [ref]) {
        debugPrint('Change received: ${payload.toString()} refs: $ref');
        streamHandler(payload);
      },
    );

    channel.subscribe();

    return channel;
  }

  @override
  Future<void> unsubscribeToTeamUsers(RealtimeChannel channel) async {
    await supabase.removeChannel(channel);
  }

  @override
  Future<List<TeamUserEntity>> getTeamUsers(String teamId) async {
    try {
      final List<Map<String, dynamic>> teamUsersData = await supabase
          .from('team_users')
          .select<PostgrestList>('*, user:users(*)')
          .eq('team_id', teamId);

      List<TeamUserEntity> teamUsers = [];

      for (int i = 0; i < teamUsersData.length; i++) {
        teamUsers.add(TeamUserEntity.fromJson(teamUsersData[i]));
      }

      return teamUsers;
    } on Failure catch (_) {
      rethrow;
    } on PostgrestException catch (error) {
      debugPrint("fetch user postgre error: $error");
      throw Failure.request(code: error.code);
    } on Exception catch (error) {
      debugPrint("fetch user unexpected error occured $error");
      throw Failure.unexpected();
    }
  }

  @override
  Future<List<TeamEntity>> getLeadingTeams(String searchName) async {
    try {
      final User? user = supabase.auth.currentUser;

      final List<Map<String, dynamic>> leadingTeamsRes = await supabase
          .from('teams')
          .select<PostgrestList>('*, team_users!inner(user_id, is_owner)')
          .ilike('team_name', '%$searchName%')
          .eq('team_users.is_owner', true)
          .eq('team_users.user_id', user!.id)
          .eq('is_current', true);

      List<TeamEntity> leadingTeams = [];

      for (int i = 0; i < leadingTeamsRes.length; i++) {
        var avatarURL = leadingTeamsRes[i]['avatar'] == null
            ? ''
            : await supabase.storage
                .from('team_avatar_bucket')
                .createSignedUrl('${leadingTeamsRes[i]['avatar']}', 1000);
        leadingTeamsRes[i]['avatar_url'] = avatarURL;
        leadingTeams.add(TeamEntity.fromJson(leadingTeamsRes[i]));
      }

      return leadingTeams;
    } on Failure catch (_) {
      rethrow;
    } on PostgrestException catch (error) {
      debugPrint("fetch leading teams postgre error: $error");
      throw Failure.request(code: error.code);
    } on StorageException catch (error) {
      debugPrint("fetch leading teams storage error: $error");
      throw Failure.request(code: error.statusCode);
    } on Exception catch (error) {
      debugPrint("fetch leading teams unexpected error occured $error");
      throw Failure.unexpected();
    }
  }

  @override
  Future<List<TeamEntity>> getParticipatingTeams(String searchName) async {
    try {
      final User? user = supabase.auth.currentUser;

      final List<Map<String, dynamic>> participatingTeamsRes = await supabase
          .from('teams')
          .select<PostgrestList>('*, team_users!inner(user_id, is_owner)')
          .ilike('team_name', '%$searchName%')
          .eq('team_users.is_owner', false)
          .eq('team_users.user_id', user!.id)
          .eq('is_current', true);

      List<TeamEntity> participatingTeams = [];

      for (int i = 0; i < participatingTeamsRes.length; i++) {
        var avatarURL = participatingTeamsRes[i]['avatar'] == null
            ? ''
            : await supabase.storage
                .from('team_avatar_bucket')
                .createSignedUrl('${participatingTeamsRes[i]['avatar']}', 1000);
        participatingTeamsRes[i]['avatar_url'] = avatarURL;
        participatingTeams.add(TeamEntity.fromJson(participatingTeamsRes[i]));
      }

      return participatingTeams;
    } on Failure catch (_) {
      rethrow;
    } on PostgrestException catch (error) {
      debugPrint("fetch leading teams postgre error: $error");
      throw Failure.request(code: error.code);
    } on StorageException catch (error) {
      debugPrint("fetch leading teams storage error: $error");
      throw Failure.request(code: error.statusCode);
    } on Exception catch (error) {
      debugPrint("fetch leading teams unexpected error occured $error");
      throw Failure.unexpected();
    }
  }

  ///Team Home Page

  @override
  Future<GetTeamHomeData> getTeamHomeData() async {
    final User? user = supabase.auth.currentUser;
    var userData = await supabase
        .from('users')
        .select('*, user_avatars(*)')
        .eq('id', user!.id)
        .single();

    UserEntity userEntity = UserEntity.fromJson(userData);

    var memberTeamData = await supabase
        .from('teams')
        .select('*, team_users!inner(user_id, is_owner) , milestones(*)')
        .eq('team_users.is_owner', false)
        .eq('team_users.user_id', user.id)
        .eq('is_current', true);

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

  @override
  Future<GetTeamData> getTeamData(String teamId) async {
    var teamMemberData = await supabase
        .from('team_users')
        .select('*, user:users(*)')
        .eq('team_id', teamId)
        .order('is_owner');

    List<TeamUserEntity> teamMembers = [];
    for (int i = 0; i < teamMemberData.length; i++) {
      teamMembers.add(TeamUserEntity.fromJson(teamMemberData[i]));
    }

    var milestone =
        await supabase.from('milestones').select().eq('team_id', teamId);

    var teamData = await supabase
        .from('teams')
        .select('*, team_users(*)')
        .eq('id', teamId);
    var teamAvatarURL = teamData[0]['avatar'] == null
        ? ''
        : await supabase.storage
            .from('team_avatar_bucket')
            .createSignedUrl('${teamData[0]['avatar']}', 100);
    teamData[0]['avatar_url'] = teamAvatarURL;
    TeamEntity team = TeamEntity.fromJson(teamData[0]);

    return GetTeamData(teamMembers, team, milestone);
  }

  @override
  void saveMilestoneData({required bool val, required String taskId}) async {
    await supabase.from('milestones').update({
      'is_completed': val,
      'updated_at': DateTime.now().toString()
    }).eq('id', taskId);
  }

  @override
  void addMilestone(
      {required String title,
      required String startDate,
      required String endDate,
      required String teamId,
      required String description}) async {
    await supabase.from('milestones').insert({
      'title': title,
      'start_date': startDate,
      'end_date': endDate,
      'team_id': teamId,
      'description': description,
    });
  }

  @override
  void listTeam({required String teamId, required bool isListed}) async {
    await supabase.from('teams').update({
      'is_listed': isListed,
      'updated_at': DateTime.now().toString()
    }).eq('id', teamId);
  }

  @override
  void disbandTeam({required String teamId}) async {
    await supabase.from('teams').update({
      'is_current': false,
      'is_listed': false,
      'updated_at': DateTime.now().toString()
    }).eq('id', teamId);
  }

  @override
  void leaveTeam({required String teamId}) async {
    final User? user = supabase.auth.currentUser;
    var teamData =
        await supabase.from('teams').select().eq('id', teamId).single();

    await supabase.from('teams').update(
        {'current_members': teamData['current_members'] - 1}).eq('id', teamId);

    await supabase
        .from('team_users')
        .delete()
        .match({'user_id': user!.id, 'team_id': teamId});
  }

  @override
  void editMilestone(
      {required String taskId,
      required String title,
      required String startDate,
      required String endDate,
      required String description}) async {
    await supabase.from('milestones').update({
      'title': title,
      'start_date': startDate,
      'end_date': endDate,
      'description': description,
    }).eq('id', taskId);
  }

  @override
  void deleteMilestone({required String taskId}) async {
    await supabase.from('milestones').delete().match({'id': taskId});
  }

  @override
  void deleteMember(
      {required String memberId,
      required String teamId,
      required int newCurrentMember}) async {
    await supabase
        .from('teams')
        .update({'current_members': newCurrentMember}).eq('id', teamId);
    await supabase.from('team_users').delete().match({'id': memberId});
  }

  //Manage Team Page

  @override
  Future<GetManageTeamData> getManageTeamData(String teamId) async {
    var applicantUserData = await supabase
        .from('users')
        .select(
            '*, team_applicants!inner(id, team_id, status), user_avatars(*), degree_programmes(*), experiences(*), accomplishments(*),preferences(*, categories_preferences(categories(*)), skills_preferences(selected_skills(*)))')
        .eq('team_applicants.team_id', teamId)
        .eq('team_applicants.status', 'pending');

    var rolesData =
        await supabase.from('roles_open').select().eq('team_id', teamId);

    return GetManageTeamData(applicantUserData, rolesData);
  }

  @override
  void addRoles(
      {required String title,
      required String description,
      required String teamId}) async {
    await supabase.from('roles_open').insert(
        {'title': title, 'description': description, 'team_id': teamId});
  }

  @override
  void updateRoles(
      {required String title,
      required String description,
      required String roleId}) async {
    await supabase.from('roles_open').update({
      'title': title,
      'description': description,
      'updated_at': DateTime.now().toString()
    }).eq('id', roleId);
  }

  @override
  void deleteRoles({required String roleId}) async {
    await supabase.from('roles_open').delete().eq('id', roleId);
  }

  //Create & Edit Team Page

  @override
  Future<TeamEntity> getEditCreateTeamData(String teamId) async {
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

  @override
  void updateTeamData({
    required String teamId,
    required String teamName,
    required String description,
    required String startDate,
    required String endDate,
    required String category,
    required String commitment,
    required String maxMember,
    required List<SkillEntity> interest,
    required File? avatar,
  }) async {
    final previousAvatar =
        await supabase.from('teams').select('avatar').eq('id', teamId).single();
    if (avatar.toString() == 'null') {
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
    } else {
      await supabase.from('teams').update({
        'team_name': teamName,
        'description': description,
        'start_date': startDate,
        'end_date': endDate == '' ? null : endDate,
        'project_category': category,
        'commitment': commitment,
        'max_members': maxMember,
        'interest': interest,
        'avatar': '${teamId}_avatar',
        'updated_at': DateTime.now().toString()
      }).eq('id', teamId);
      if (previousAvatar['avatar'] == null) {
        await supabase.storage.from('team_avatar_bucket').upload(
            '${teamId}_avatar', avatar!,
            fileOptions:
                const FileOptions(cacheControl: '3600', upsert: false));
      } else {
        await supabase.storage.from('team_avatar_bucket').update(
            '${teamId}_avatar', avatar!,
            fileOptions:
                const FileOptions(cacheControl: '3600', upsert: false));
      }
    }
  }

  @override
  void createNewTeam(
      {required String userId,
      required String teamName,
      required String description,
      required String startDate,
      required String endDate,
      required String category,
      required String commitment,
      required String maxMember,
      required List<SkillEntity> interest,
      required List<String> interestName,
      required File? avatar}) async {
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
      'interest_name': interestName,
      'avatar': avatar.toString() == 'null' ? null : '${teamId}_avatar'
      //: '${teamId}_avatar${avatar.toString().substring(0, avatar.toString().length - 1).substring(avatar.toString().length - (5 - avatar.toString().substring(avatar.toString().length - 5).indexOf('.')))}',
    });

    avatar.toString() == 'null'
        ? debugPrint('No Picture Uploaded')
        : await supabase.storage.from('team_avatar_bucket').upload(
            '${teamId}_avatar', avatar!,
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

  @override
  Future<GetApplicantData> getApplicantData(String applicationID) async {
    var applicantUserData = await supabase
        .from('users')
        .select(
            '*, team_applicants!inner(id), degree_programmes(name), user_avatars(*)')
        .eq('team_applicants.id', applicationID)
        .single();

    var avatarURL = applicantUserData['user_avatars'] == null
        ? ''
        : await supabase.storage.from('user_avatar_bucket').createSignedUrl(
            '${applicantUserData['user_avatars']['file_identifier']}', 60);
    applicantUserData['avatar_url'] = avatarURL;

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
        .eq('user_id', applicantUserData['id'])
        .order('start_date');

    var accomplishmentData = await supabase
        .from('accomplishments')
        .select()
        .eq('user_id', applicantUserData['id'])
        .order('start_date');

    return GetApplicantData(team, experienceData, accomplishmentData);
  }

  @override
  void acceptApplicant(
      {required String applicationID, required int currentMember}) async {
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

    await supabase
        .from('team_applicants')
        .update({'status': 'accepted'}).eq('id', applicationID);
  }

  @override
  void rejectApplicant({required String applicationID}) async {
    await supabase
        .from('team_applicants')
        .update({'status': 'rejected'}).eq('id', applicationID);
  }
}
