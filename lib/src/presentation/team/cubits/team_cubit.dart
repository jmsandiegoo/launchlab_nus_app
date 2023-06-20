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
        .select('*, users(first_name, last_name)')
        .eq('team_id', teamId);
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
    return [teamMemberData, completedMilestones, incompleteMilestone, teamData];
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
    await supabase.from('milestones').update({
      'is_listed': true,
      'updated_at': DateTime.now().toString()
    }).eq('id', teamId);
    debugPrint("Listed");
  }

  void unlistTeam({teamId}) async {
    await supabase.from('milestones').update({
      'is_listed': false,
      'updated_at': DateTime.now().toString()
    }).eq('id', teamId);
    debugPrint("Unlisted");
  }

  void disbandTeam({teamId}) async {
    await supabase.from('milestones').update({
      'is_current': false,
      'updated_at': DateTime.now().toString()
    }).eq('id', teamId);
    debugPrint("Unlisted");
  }

  void deleteTask({taskId}) async {
    await supabase.from('milestones').delete().match({'id': taskId});
    debugPrint("Deleted Task");
  }
}
