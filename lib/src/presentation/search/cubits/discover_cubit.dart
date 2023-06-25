import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@immutable
class DiscoverState extends Equatable {
  final String searchTerm;

  @override
  List<Object?> get props => [searchTerm];

  const DiscoverState({this.searchTerm = ""});
}

class DiscoverCubit extends Cubit<DiscoverState> {
  DiscoverCubit() : super(const DiscoverState());

  final supabase = Supabase.instance.client;

  getData(searchTerm) async {
    var teamNameData = await supabase
        .from('teams')
        .select('*, roles_open(title)')
        .eq('is_listed', true)
        .textSearch('team_name', searchTerm)
        .limit(5);

    var teamDescriptionData = await supabase
        .from('teams')
        .select()
        .eq('is_listed', true)
        .textSearch('description', searchTerm)
        .limit(5);
    var user = supabase.auth.currentUser;

    for (int i = 0; i < teamNameData.length; i++) {
      var avatarURL = teamNameData[i]['avatar'] == null
          ? ''
          : await supabase.storage
              .from('team_avatar_bucket')
              .createSignedUrl('${teamNameData[i]['avatar']}', 30);
      teamNameData[i]['avatar_url'] = avatarURL;
    }

    for (int i = 0; i < teamDescriptionData.length; i++) {
      var avatarURL = teamDescriptionData[i]['avatar'] == null
          ? ''
          : await supabase.storage
              .from('team_avatar_bucket')
              .createSignedUrl('${teamDescriptionData[i]['avatar']}', 30);
      teamDescriptionData[i]['avatar_url'] = avatarURL;
    }
    return [teamNameData, teamDescriptionData, user!.id];
  }

  void setSearchState(String value) {
    emit(DiscoverState(searchTerm: value));
  }
}
