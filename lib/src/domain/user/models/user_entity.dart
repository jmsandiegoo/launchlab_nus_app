import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    this.id,
    required this.isOnboarded,
    required this.username,
    this.firstName,
    this.lastName,
    this.title,
    this.about,
    this.degreeProgrammeId,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final bool isOnboarded;
  final String username;
  final String? firstName;
  final String? lastName;
  final String? title;
  final String? about;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final String? degreeProgrammeId;

  UserEntity setAvatar({String? avatar}) {
    return UserEntity(
      id: id,
      isOnboarded: isOnboarded,
      username: username,
      firstName: firstName,
      lastName: lastName,
      title: title,
      about: about,
      degreeProgrammeId: degreeProgrammeId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  UserEntity copyWith({
    String? id,
    bool? isOnboarded,
    String? username,
    String? firstName,
    String? lastName,
    String? title,
    String? avatar,
    String? resume,
    String? about,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? degreeProgrammeId,
  }) {
    return UserEntity(
      id: id ?? this.id,
      isOnboarded: isOnboarded ?? this.isOnboarded,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      title: title ?? this.title,
      about: about ?? this.about,
      degreeProgrammeId: degreeProgrammeId ?? this.degreeProgrammeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  UserEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        isOnboarded = json['is_onboarded'],
        username = json['username'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        title = json['title'],
        about = json['about'],
        degreeProgrammeId = json['degree_programme_id'],
        createdAt = DateTime.tryParse(json['created_at'].toString()),
        updatedAt = DateTime.tryParse(json['updated_at'].toString());

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_onboarded': isOnboarded,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'title': title,
      'about': about,
      'degree_programme_id': degreeProgrammeId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        isOnboarded,
        username,
        firstName,
        lastName,
        title,
        about,
        degreeProgrammeId,
        createdAt,
        updatedAt,
      ];
}
