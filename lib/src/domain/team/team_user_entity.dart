import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';

class TeamUserEntity extends Equatable {
  const TeamUserEntity(
      this.id, this.positon, this.isOwner, this.userId, this.user);

  @override
  List<Object?> get props => [id, positon, isOwner];

  final String id;
  final String positon;
  final bool isOwner;
  final String userId;
  final UserEntity user;

  TeamUserEntity copyWith({
    String? id,
    String? positon,
    bool? isOwner,
    String? userId,
    UserEntity? user,
  }) {
    return TeamUserEntity(
      id ?? this.id,
      positon ?? this.positon,
      isOwner ?? this.isOwner,
      userId ?? this.userId,
      user ?? this.user,
    );
  }

  TeamUserEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        positon = json['position'],
        isOwner = json['is_owner'],
        userId = json['user_id'],
        user = UserEntity.fromJson(json['user']);

  String getFullName() {
    return '${user.firstName} ${user.lastName}';
  }

  String? getAvatarURL() {
    return user.userAvatar?.signedUrl;
  }
}
