import 'dart:async';
import 'dart:io';

import 'package:launchlab/src/domain/common/models/skill_entity.dart';
import 'package:launchlab/src/domain/team/responses/get_applicant_data.dart';
import 'package:launchlab/src/domain/team/responses/get_manage_team_data.dart';
import 'package:launchlab/src/domain/team/responses/get_team_data.dart';
import 'package:launchlab/src/domain/team/team_entity.dart';
import 'package:launchlab/src/domain/team/team_user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../responses/get_team_home_data.dart';

/// Auth Repository Interface
/// A blueprint to specify the app logic

abstract class TeamRepositoryImpl {
  RealtimeChannel subscribeToTeamUsers(
      {required String teamId,
      required FutureOr<void> Function(dynamic payload) streamHandler});

  Future<void> unsubscribeToTeamUsers(RealtimeChannel channel);

  Future<List<TeamUserEntity>> getTeamUsers(String teamId);

  Future<List<TeamEntity>> getLeadingTeams(String searchName);

  Future<List<TeamEntity>> getParticipatingTeams(String searchName);

  Future<GetTeamHomeData> getTeamHomeData();

  Future<GetTeamData> getTeamData(String teamId);

  void saveMilestoneData({required bool val, required String taskId});

  void addMilestone(
      {required String title,
      required String startDate,
      required String endDate,
      required String teamId,
      required String description});

  void editMilestone(
      {required String taskId,
      required String title,
      required String startDate,
      required String endDate,
      required String description});

  void listTeam({required String teamId, required bool isListed});

  void disbandTeam({required String teamId});

  void leaveTeam({required String teamId});

  void deleteMilestone({required String taskId});

  void deleteMember(
      {required String memberId,
      required String teamId,
      required int newCurrentMember});

  Future<GetManageTeamData> getManageTeamData(String teamId);

  void addRoles(
      {required String title,
      required String description,
      required String teamId});

  void updateRoles(
      {required String title,
      required String description,
      required String roleId});

  void deleteRoles({required String roleId});

  Future<TeamEntity> getEditCreateTeamData(String teamId);

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
  });

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
      required File? avatar});

  Future<GetApplicantData> getApplicantData(String applicationID);

  void acceptApplicant(
      {required String applicationID, required int currentMember});

  void rejectApplicant({required String applicationID});
}
