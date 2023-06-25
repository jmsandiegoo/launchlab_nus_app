import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/authentication/repository/auth_repository.dart';
//import 'package:launchlab/src/utils/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@immutable
class TeamHomeState extends Equatable {
  final bool isLeading;
  const TeamHomeState({this.isLeading = false});

  @override
  List<Object?> get props => [isLeading];
}

class TeamHomeCubit extends Cubit<TeamHomeState> {
  final AuthRepository _authRepository;

  TeamHomeCubit(this._authRepository) : super(const TeamHomeState());

  Future<void> handleSignOut() async {
    await _authRepository.signOut();
  }

  final supabase = Supabase.instance.client;
  getData(data) async {
    final User? user = supabase.auth.currentUser;

    var userData = await supabase
        .from('users')
        .select('id, first_name, avatar')
        .eq('id', user!.id);
    var memberTeamData = await supabase
        .from('teams')
        .select('*, team_users!inner(user_id, is_owner) , milestones(*)')
        .eq('team_users.is_owner', false)
        .eq('team_users.user_id', user.id)
        .eq('is_current', true);

    var ownerTeamData = await supabase
        .from('teams')
        .select('*, team_users!inner(user_id, is_owner), milestones(*)')
        .eq('team_users.is_owner', true)
        .eq('team_users.user_id', user.id)
        .eq('is_current', true);

    var userAvatarURL = userData[0]['avatar'] == null
        ? ''
        : await supabase.storage
            .from('user_avatar_bucket')
            .createSignedUrl('${userData[0]['avatar']}', 30);

    for (int i = 0; i < memberTeamData.length; i++) {
      var avatarURL = memberTeamData[i]['avatar'] == null
          ? ''
          : await supabase.storage
              .from('team_avatar_bucket')
              .createSignedUrl('${memberTeamData[i]['avatar']}', 30);
      memberTeamData[i]['avatar_url'] = avatarURL;
    }

    for (int i = 0; i < ownerTeamData.length; i++) {
      var avatarURL = ownerTeamData[i]['avatar'] == null
          ? ''
          : await supabase.storage
              .from('team_avatar_bucket')
              .createSignedUrl('${ownerTeamData[i]['avatar']}', 30);
      ownerTeamData[i]['avatar_url'] = avatarURL;
    }

    return [memberTeamData, ownerTeamData, userData, userAvatarURL];
  }

  void setIsLeadingState(bool value) {
    emit(TeamHomeState(isLeading: value));
  }
}
