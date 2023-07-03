import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/domain/team/responses/get_manage_team_data.dart';
import 'package:launchlab/src/domain/team/role_entity.dart';
import 'package:launchlab/src/domain/team/user_entity.dart';

@immutable
class ManageTeamState extends Equatable {
  final List<UserEntity> applicantUserData;
  final List<RoleEntity> rolesData;
  final bool isLoaded;

  @override
  List<Object?> get props => [applicantUserData, rolesData, isLoaded];

  const ManageTeamState({
    this.applicantUserData = const [],
    this.rolesData = const [],
    this.isLoaded = false,
  });

  ManageTeamState copyWith({
    List<UserEntity>? applicantUserData,
    List<RoleEntity>? rolesData,
    bool? isLoaded,
  }) {
    return ManageTeamState(
      applicantUserData: applicantUserData ?? this.applicantUserData,
      rolesData: rolesData ?? this.rolesData,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}

class ManageTeamCubit extends Cubit<ManageTeamState> {
  final TeamRepository _teamRepository;

  ManageTeamCubit(this._teamRepository) : super(const ManageTeamState());

  void getData(teamId) async {
    final GetManageTeamData res =
        await _teamRepository.getManageTeamData(teamId);

    final newState = state.copyWith(
        applicantUserData: res.users,
        rolesData: res.getAllRoles(),
        isLoaded: true);
    debugPrint("Manage Team State Emitted");
    emit(newState);
  }

  void loading() {
    emit(state.copyWith(isLoaded: false));
  }

  void addRoles({title, description, teamId}) {
    _teamRepository.addRoles(
        title: title, description: description, teamId: teamId);
    debugPrint("Role Added");
  }

  void updateRoles({title, description, roleId}) {
    _teamRepository.updateRoles(
        title: title, description: description, roleId: roleId);
    debugPrint("Role Updated");
  }

  void deleteRoles({roleId}) async {
    _teamRepository.deleteRoles(roleId: roleId);
    debugPrint("Role Deleted");
  }
}
