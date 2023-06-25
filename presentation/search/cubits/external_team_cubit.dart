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
    var teamData = await supabase
        .from('teams')
        .select('*, team_users(user_id), roles_open(title, description)')
        .eq('id', teamId);

    var ownerDetails = await supabase
        .from('users')
        .select(
            'first_name, last_name, avatar, team_users!inner(team_id ,is_owner)')
        .eq('team_users.is_owner', true)
        .eq('team_users.team_id', teamId);

    var applicants = await supabase
        .from('team_applicants')
        .select('user_id')
        .eq('team_id', teamId);

    var teamAvatarURL = teamData[0]['avatar'] == null
        ? ''
        : await supabase.storage
            .from('team_avatar_bucket')
            .createSignedUrl('${teamData[0]['avatar']}', 30);
    teamData[0]['avatar_url'] = teamAvatarURL;

    var teamOwnerURL = ownerDetails[0]['avatar'] == null
        ? ''
        : await supabase.storage
            .from('user_avatar_bucket')
            .createSignedUrl('${ownerDetails[0]['avatar']}', 30);
    ownerDetails[0]['avatar_url'] = teamOwnerURL;
    return [
      teamData,
      ownerDetails,
      applicants,
    ];
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
