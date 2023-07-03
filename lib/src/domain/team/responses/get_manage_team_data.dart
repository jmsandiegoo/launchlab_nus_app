import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/team/role_entity.dart';
import 'package:launchlab/src/domain/team/user_entity.dart';

class GetManageTeamData extends Equatable {
  const GetManageTeamData(this.users, this.roles);

  final List<UserEntity> users;
  final List roles;

  @override
  List<Object?> get props => [users, roles];

  List<RoleEntity> getAllRoles() {
    List<RoleEntity> allRoles = [];
    for (var element in roles) {
      allRoles.add(RoleEntity.fromJson(element));
    }
    return allRoles;
  }
}
