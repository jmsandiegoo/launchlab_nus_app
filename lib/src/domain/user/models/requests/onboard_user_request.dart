import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:launchlab/src/domain/common/models/category_entity.dart';
import 'package:launchlab/src/domain/common/models/skill_entity.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';

@immutable
class OnboardUserRequest extends Equatable {
  const OnboardUserRequest({
    this.userAvatar,
    this.userResume,
    required this.user,
    required this.selectedSkills,
    required this.selectedCategories,
    required this.experiences,
    required this.accomplishments,
  });

  final File? userAvatar;
  final File? userResume;
  final UserEntity user;
  final List<SkillEntity> selectedSkills;
  final List<CategoryEntity> selectedCategories;
  final List<ExperienceEntity> experiences;
  final List<AccomplishmentEntity> accomplishments;

  OnboardUserRequest copyWith({
    File? userAvatar,
    File? userResume,
    UserEntity? user,
    List<SkillEntity>? selectedSkills,
    List<CategoryEntity>? selectedCategories,
    List<ExperienceEntity>? experiences,
    List<AccomplishmentEntity>? accomplishments,
  }) {
    return OnboardUserRequest(
      userAvatar: userAvatar ?? this.userAvatar,
      userResume: userResume ?? this.userResume,
      user: user ?? this.user,
      selectedSkills: selectedSkills ?? this.selectedSkills,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      experiences: experiences ?? this.experiences,
      accomplishments: accomplishments ?? this.accomplishments,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'selected_skills': selectedSkills.map((skill) => skill.toJson()).toList(),
      'selected_categories':
          selectedCategories.map((cat) => cat.toJson()).toList(),
      'experiences': experiences.map((exp) => exp.toJson()).toList(),
      'accomplishments': accomplishments
          .map((accomplishment) => accomplishment.toJson())
          .toList(),
    };
  }

  @override
  List<Object?> get props => [
        userAvatar,
        userResume,
        user,
        selectedSkills,
        selectedCategories,
        experiences,
        accomplishments,
      ];
}
