import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@immutable
class TeamState extends Equatable {
  @override
  List<Object?> get props => [];

  const TeamState();
}

class TeamCubit extends Cubit<TeamState> {
  TeamCubit() : super(const TeamState());
  final supabase = Supabase.instance.client;
  getData(teamId) async {
    var teamMemberData = await supabase
        .from('team_users')
        .select('*, users(first_name, last_name, avatar)')
        .eq('team_id', teamId);

    for (int i = 0; i < teamMemberData.length; i++) {
      var avatarURL = teamMemberData[i]['users']['avatar'] == null
          ? ''
          : await supabase.storage.from('user_avatar_bucket').createSignedUrl(
              '${teamMemberData[i]['users']['avatar']}', 10000);
      teamMemberData[i]['users']['avatar_url'] = avatarURL;
    }

    var completedMilestones = await supabase
        .from('milestones')
        .select()
        .eq('team_id', teamId)
        .eq('is_completed', true);
    var incompleteMilestone = await supabase
        .from('milestones')
        .select()
        .eq('team_id', teamId)
        .eq('is_completed', false);

    var teamData = await supabase.from('teams').select().eq('id', teamId);

    var teamAvatarURL = teamData[0]['avatar'] == null
        ? ''
        : await supabase.storage
            .from('team_avatar_bucket')
            .createSignedUrl('${teamData[0]['avatar']}', 30);

    teamData[0]['avatar_url'] = teamAvatarURL;

    return [
      teamMemberData,
      completedMilestones,
      incompleteMilestone,
      teamData,
    ];
  }

  void saveMilestoneCheckData({val, taskId}) async {
    await supabase.from('milestones').update({
      'is_completed': val,
      'updated_at': DateTime.now().toString()
    }).eq('id', taskId);
    debugPrint("Check Updated");
  }

  void addMilestone({title, startDate, endDate, teamData}) async {
    await supabase.from('milestones').insert({
      'title': title,
      'start_date': startDate,
      'end_date': endDate,
      'team_id': teamData['id']
    });
    debugPrint("Milestone Added");
  }

  void listTeam({teamId}) async {
    await supabase.from('teams').update({
      'is_listed': true,
      'updated_at': DateTime.now().toString()
    }).eq('id', teamId);
    debugPrint("Listed");
  }

  void unlistTeam({teamId}) async {
    await supabase.from('teams').update({
      'is_listed': false,
      'updated_at': DateTime.now().toString()
    }).eq('id', teamId);
    debugPrint("Unlisted");
  }

  void disbandTeam({teamId}) async {
    debugPrint(teamId);
    await supabase.from('teams').update({
      'is_current': false,
      'is_listed': false,
      'updated_at': DateTime.now().toString()
    }).eq('id', teamId);
    debugPrint("Team Disbanded");
  }

  void deleteTask({taskId}) async {
    await supabase.from('milestones').delete().match({'id': taskId});
    debugPrint("Deleted Task");
  }

  void deleteMember({memberId, teamId, newCurrentMember}) async {
    await supabase
        .from('teams')
        .update({'current_members': newCurrentMember}).eq('id', teamId);
    await supabase.from('team_users').delete().match({'id': memberId});
    debugPrint("Deleted Member");
  }
}
