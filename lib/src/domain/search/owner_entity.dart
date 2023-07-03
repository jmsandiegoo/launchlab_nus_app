import 'package:equatable/equatable.dart';

class OwnerEntity extends Equatable {
  const OwnerEntity(this.firstName, this.lastName, this.avatar, this.avatarURL);

  @override
  List<Object?> get props => [firstName, lastName, avatar, avatarURL];

  final String firstName;
  final String lastName;
  final String? avatar;
  final String avatarURL;

  OwnerEntity.fromJson(Map<String, dynamic> json)
      : firstName = json['first_name'],
        lastName = json['last_name'],
        avatar = json['avatar'],
        avatarURL = json['avatar_url'];

  String ownerFullName() {
    return "$firstName $lastName";
  }
}
