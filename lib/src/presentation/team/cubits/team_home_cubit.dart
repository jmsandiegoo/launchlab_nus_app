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
  getData() async {
    var userData = await supabase
        .from('users')
        .select('id, first_name')
        .eq('id', 'ca1956b9-0bc8-4b82-8b08-a59a24c13697');
    var memberTeamData = await supabase
        .from('teams')
        .select('*, team_users!inner(user_id, is_owner) , milestones(*)')
        .eq('team_users.is_owner', false)
        .eq('team_users.user_id', 'ca1956b9-0bc8-4b82-8b08-a59a24c13697')
        .eq('is_current', true);

    var ownerTeamData = await supabase
        .from('teams')
        .select('*, team_users!inner(user_id, is_owner), milestones(*)')
        .eq('team_users.is_owner', true)
        .eq('team_users.user_id', 'ca1956b9-0bc8-4b82-8b08-a59a24c13697')
        .eq('is_current', true);

    return [memberTeamData, ownerTeamData, userData];
  }

  void setIsLeadingState(bool value) {
    emit(TeamHomeState(isLeading: value));
  }
}
