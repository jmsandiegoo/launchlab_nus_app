import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';

class TeamApplicantEntity extends Equatable {
  const TeamApplicantEntity(this.id, this.status, this.user, this.teamId);

  @override
  List<Object?> get props => [id, status, user, teamId];

  final String id;
  final String status;
  final String teamId;
  final UserEntity user;

  TeamApplicantEntity copyWith({
    String? id,
    String? status,
    String? teamId,
    UserEntity? user,
  }) {
    return TeamApplicantEntity(
      id ?? this.id,
      status ?? this.status,
      user ?? this.user,
      teamId ?? this.teamId,
    );
  }

  String getFullName() {
    return '${user.firstName} ${user.lastName}';
  }

  String? getAvatarURL() {
    return user.userAvatar?.signedUrl;
  }
}
