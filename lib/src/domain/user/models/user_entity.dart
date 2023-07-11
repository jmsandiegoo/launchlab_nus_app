import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';
import 'package:launchlab/src/domain/user/models/preference_entity.dart';
import 'package:launchlab/src/domain/user/models/user_avatar_entity.dart';
import 'package:launchlab/src/domain/user/models/user_resume_entity.dart';

import 'accomplishment_entity.dart';
import 'experience_entity.dart';

class UserEntity extends Equatable {
  const UserEntity({
    this.id,
    required this.isOnboarded,
    required this.username,
    this.firstName,
    this.lastName,
    this.title,
    this.about,
    this.createdAt,
    this.updatedAt,
    this.degreeProgrammeId,
    this.userPreference,
    this.userAvatar,
    this.userResume,
    this.userDegreeProgramme,
    this.userExperiences = const [],
    this.userAccomplishments = const [],
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

  final PreferenceEntity? userPreference;
  final UserAvatarEntity? userAvatar;
  final UserResumeEntity? userResume;
  final DegreeProgrammeEntity? userDegreeProgramme;
  final List<ExperienceEntity> userExperiences;
  final List<AccomplishmentEntity> userAccomplishments;

  UserEntity setRelations(
      {PreferenceEntity? userPreference,
      UserAvatarEntity? userAvatar,
      UserResumeEntity? userResume,
      DegreeProgrammeEntity? userDegreeProgramme,
      List<ExperienceEntity>? userExperiences,
      List<AccomplishmentEntity>? userAccomplishments}) {
    return UserEntity(
      id: id,
      isOnboarded: isOnboarded,
      username: username,
      firstName: firstName,
      lastName: lastName,
      title: title,
      about: about,
      createdAt: createdAt,
      updatedAt: updatedAt,
      degreeProgrammeId: degreeProgrammeId,
      userPreference: userPreference,
      userAvatar: userAvatar,
      userResume: userResume,
      userDegreeProgramme: userDegreeProgramme,
      userExperiences: userExperiences ?? this.userExperiences,
      userAccomplishments: userAccomplishments ?? this.userAccomplishments,
    );
  }

  String getFullName() {
    return "$firstName $lastName";
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

    /// relational objects
    PreferenceEntity? userPreference,
    UserAvatarEntity? userAvatar,
    UserResumeEntity? userResume,
    DegreeProgrammeEntity? userDegreeProgramme,
    List<ExperienceEntity>? userExperiences,
    List<AccomplishmentEntity>? userAccomplishments,
  }) {
    return UserEntity(
      id: id ?? this.id,
      isOnboarded: isOnboarded ?? this.isOnboarded,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      title: title ?? this.title,
      about: about ?? this.about,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      degreeProgrammeId: degreeProgrammeId ?? this.degreeProgrammeId,
      userPreference: userPreference,
      userAvatar: userAvatar,
      userResume: userResume,
      userDegreeProgramme: userDegreeProgramme,
      userExperiences: userExperiences ?? this.userExperiences,
      userAccomplishments: userAccomplishments ?? this.userAccomplishments,
    );
  }

  UserEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        isOnboarded = json['is_onboarded'],
        username = json['username'] ?? '',
        firstName = json['first_name'],
        lastName = json['last_name'],
        title = json['title'],
        about = json['about'],
        degreeProgrammeId = json['degree_programme_id'],
        createdAt = DateTime.tryParse(json['created_at'].toString()),
        updatedAt = DateTime.tryParse(json['updated_at'].toString()),
        userPreference = json['preference'] != null
            ? PreferenceEntity.fromJson(json['preference'])
            : null,
        userAvatar = null,
        userResume = null,
        userDegreeProgramme = json['degree_programme'] != null
            ? DegreeProgrammeEntity.fromJson(json['degree_programme'])
            : null,
        userAccomplishments = (json['accomplishments']
                    ?.map((item) => AccomplishmentEntity.fromJson(item))
                    .toList() ??
                [])
            .cast<AccomplishmentEntity>(),
        userExperiences = (json['experiences']
                    ?.map((item) => ExperienceEntity.fromJson(item))
                    .toList() ??
                [])
            .cast<ExperienceEntity>();

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

  Map<String, dynamic> toJsonWithRelations() {
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
      'preference': userPreference?.toJson(),
      'degree_programme': userDegreeProgramme?.toJson(),
      'experiences': userExperiences.map((item) => item.toJson()).toList(),
      'accomplishments':
          userAccomplishments.map((item) => item.toJson()).toList(),
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
