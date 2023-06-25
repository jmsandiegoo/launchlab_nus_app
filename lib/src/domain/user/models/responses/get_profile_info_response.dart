import 'dart:core';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/domain/user/models/preference_entity.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';

@immutable
class GetProfileInfoResponse extends Equatable {
  const GetProfileInfoResponse({
    required this.userProfile,
    this.userAvatarUrl,
    required this.userDegreeProgramme,
    this.userExperiences = const [],
    this.userAccomplishments = const [],
    required this.userPreference,
  });

  final UserEntity userProfile;
  final String? userAvatarUrl;
  final DegreeProgrammeEntity userDegreeProgramme;
  final List<ExperienceEntity> userExperiences;
  final List<AccomplishmentEntity> userAccomplishments;
  final PreferenceEntity userPreference;

  @override
  List<Object?> get props => [
        userProfile,
        userAvatarUrl,
        userDegreeProgramme,
        userExperiences,
        userAccomplishments,
        userPreference,
      ];
}
