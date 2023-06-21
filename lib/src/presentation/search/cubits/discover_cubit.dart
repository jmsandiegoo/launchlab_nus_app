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
        .select()
        .eq('is_listed', false)
        .textSearch('team_name', searchTerm)
        .limit(5);

    var teamDescriptionData = await supabase
        .from('teams')
        .select()
        .eq('is_listed', false)
        .textSearch('description', searchTerm)
        .limit(5);
    var user = supabase.auth.currentUser;
    return [teamNameData, teamDescriptionData, user!.id];
  }

  void setSearchState(String value) {
    emit(DiscoverState(searchTerm: value));
  }
}
