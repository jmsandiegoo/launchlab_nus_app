import 'dart:core';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:launchlab/src/domain/common/models/skill_entity.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';

@immutable
class GetProfileInfoResponse extends Equatable {
  const GetProfileInfoResponse({
    required this.userProfile,
    required this.userAvatarUrl,
    this.userExperiences = const [],
    this.userAccomplishments = const [],
    this.userSkillsInterests = const [],
  });

  final UserEntity userProfile;
  final String userAvatarUrl;
  final List<ExperienceEntity> userExperiences;
  final List<AccomplishmentEntity> userAccomplishments;
  final List<SkillEntity> userSkillsInterests;

  @override
  List<Object?> get props => [
        userProfile,
        userAvatarUrl,
        userExperiences,
        userAccomplishments,
        userSkillsInterests,
      ];
}
