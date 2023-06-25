import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@immutable
class ManageTeamState extends Equatable {
  @override
  List<Object?> get props => [];

  const ManageTeamState();
}

class ManageTeamCubit extends Cubit<ManageTeamState> {
  ManageTeamCubit() : super(const ManageTeamState());
  final supabase = Supabase.instance.client;

  getData(teamId) async {
    var applicantData = await supabase
        .from('users')
        .select('*, team_applicants!inner(team_id)')
        .eq('team_applicants.team_id', teamId);

    var rolesData =
        await supabase.from('roles_open').select().eq('team_id', teamId);
    return [applicantData, rolesData];
  }

  void addRoles({title, description, teamId}) async {
    await supabase.from('roles_open').insert(
        {'title': title, 'description': description, 'team_id': teamId});
    debugPrint("Role Added");
  }

  void updateRoles({title, description, roleId}) async {
    await supabase.from('roles_open').update({
      'title': title,
      'description': description,
      'updated_at': DateTime.now().toString()
    }).eq('id', roleId);
    debugPrint("Role Updated");
  }
}