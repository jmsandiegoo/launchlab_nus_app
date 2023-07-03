import 'package:equatable/equatable.dart';

class TeamUserEntity extends Equatable {
  const TeamUserEntity(this.id, this.positon, this.isOwner, this.user);

  @override
  List<Object?> get props => [id, positon, isOwner];

  final String id;
  final String positon;
  final bool isOwner;
  final Map user;

  TeamUserEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        positon = json['position'],
        isOwner = json['is_owner'],
        user = json['users'];

  String getFullName() {
    return '${user['first_name']} ${user['last_name']}';
  }

  String getAvatarURL() {
    return user['avatar_url'];
  }
}
