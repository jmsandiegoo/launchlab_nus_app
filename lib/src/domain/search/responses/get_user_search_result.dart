import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/common/models/category_entity.dart';
import 'package:launchlab/src/domain/common/models/skill_entity.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/domain/user/models/preference_entity.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';

class GetSearchUserResult extends Equatable {
  const GetSearchUserResult(this.searchedUsers);

  final List searchedUsers;

  @override
  List<Object?> get props => [searchedUsers];

  List<UserEntity> getFullUserData() {
    List<UserEntity> userData = [];
    for (var searchedUser in searchedUsers) {
      UserEntity user = UserEntity.fromJson(searchedUser);
      List<ExperienceEntity> experiences = [];
      List<AccomplishmentEntity> accomplishments = [];
      List<CategoryEntity> categories = [];
      List<SkillEntity> skills = [];

      for (var category in searchedUser['preferences']
          ['categories_preferences']) {
        categories.add(CategoryEntity.fromJson(category['categories']));
      }

      for (var skill in searchedUser['preferences']['skills_preferences']) {
        skills.add(SkillEntity.fromJson(skill['selected_skills']));
      }

      for (var experience in searchedUser['experiences']) {
        experiences.add(ExperienceEntity.fromJson(experience));
      }

      for (var accomplishment in searchedUser['accomplishments']) {
        accomplishments.add(AccomplishmentEntity.fromJson(accomplishment));
      }

      user = user.copyWith(
          userDegreeProgramme:
              DegreeProgrammeEntity.fromJson(searchedUser['degree_programmes']),
          userPreference:
              PreferenceEntity(skillsInterests: skills, categories: categories),
          userExperiences: experiences,
          userAccomplishments: accomplishments);
      userData.add(user);
    }
    return userData;
  }
}
