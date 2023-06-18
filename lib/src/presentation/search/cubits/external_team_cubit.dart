import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@immutable
class ExternalTeamState extends Equatable {
  @override
  List<Object?> get props => [];

  const ExternalTeamState();
}

class ExternalTeamCubit extends Cubit<ExternalTeamState> {
  ExternalTeamCubit() : super(const ExternalTeamState());

  final supabase = Supabase.instance.client;

  getData(teamId) async {
    var teamNameData = await supabase
        .from('teams')
        .select('*, team_users(user_id)')
        .eq('id', teamId);
    var ownerName = await supabase
        .from('users')
        .select('first_name, last_name, team_users!inner(team_id ,is_owner)')
        .eq('team_users.is_owner', true)
        .eq('team_users.team_id', teamId);

    var applicants = await supabase
        .from('team_applicants')
        .select('user_id')
        .eq('team_id', teamId);

    return [teamNameData, ownerName, applicants];
  }

  applyToTeam({teamId, userId}) async {
    await supabase.from('team_applicants').insert({
      'user_id': userId,
      'team_id': teamId,
      'applied_at': DateTime.now().toString(),
    });
    debugPrint("Applied to Team");
  }
}
