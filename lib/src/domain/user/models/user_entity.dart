import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    this.id,
    required this.isOnboarded,
    this.firstName,
    this.lastName,
    this.title,
    this.avatar,
    this.resume,
    this.about,
    this.degreeProgrammeId,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final bool isOnboarded;
  final String? firstName;
  final String? lastName;
  final String? title;
  final String? avatar;
  final String? resume;
  final String? about;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final String? degreeProgrammeId;

  UserEntity copyWith({
    String? id,
    bool? isOnboarded,
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
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      title: title ?? this.title,
      avatar: avatar ?? this.avatar,
      resume: resume ?? this.resume,
      about: about ?? this.about,
      degreeProgrammeId: degreeProgrammeId ?? this.degreeProgrammeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  UserEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        isOnboarded = json['is_onboarded'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        title = json['title'],
        avatar = json['avatar'],
        resume = json['resume'],
        about = json['about'],
        degreeProgrammeId = json['degree_programme_id'],
        createdAt = DateTime.tryParse(json['created_at'].toString()),
        updatedAt = DateTime.tryParse(json['updated_at'].toString());

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_onboarded': isOnboarded,
      'first_name': firstName,
      'last_name': lastName,
      'title': title,
      'avatar': avatar,
      'resume': resume,
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
        firstName,
        lastName,
        title,
        avatar,
        resume,
        about,
        degreeProgrammeId,
        createdAt,
        updatedAt,
      ];
}
