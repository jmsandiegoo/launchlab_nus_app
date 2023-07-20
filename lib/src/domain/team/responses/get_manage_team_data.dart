import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/common/models/category_entity.dart';
import 'package:launchlab/src/domain/common/models/skill_entity.dart';
import 'package:launchlab/src/domain/team/role_entity.dart';
import 'package:launchlab/src/domain/team/team_applicant_entity.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/domain/user/models/preference_entity.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';

class GetManageTeamData extends Equatable {
  const GetManageTeamData(this.applicantData, this.roles);

  final List applicantData;
  final List roles;

  @override
  List<Object?> get props => [applicantData, roles];

  List<RoleEntity> getAllRoles() {
    List<RoleEntity> allRoles = [];
    for (var element in roles) {
      allRoles.add(RoleEntity.fromJson(element));
    }
    return allRoles;
  }

  List<TeamApplicantEntity> getAllApplicant() {
    List<TeamApplicantEntity> applicants = [];

    for (var applicant in applicantData) {
      UserEntity user = UserEntity.fromJson(applicant);

      List<ExperienceEntity> experiences = [];
      List<AccomplishmentEntity> accomplishments = [];
      List<CategoryEntity> categories = [];
      List<SkillEntity> skills = [];

      for (var category in applicant['preferences']['categories_preferences']) {
        categories.add(CategoryEntity.fromJson(category['categories']));
      }

      for (var skill in applicant['preferences']['skills_preferences']) {
        skills.add(SkillEntity.fromJson(skill['selected_skills']));
      }

      for (var experience in applicant['experiences']) {
        experiences.add(ExperienceEntity.fromJson(experience));
      }

      for (var accomplishment in applicant['accomplishments']) {
        accomplishments.add(AccomplishmentEntity.fromJson(accomplishment));
      }

      user = user.copyWith(
          userDegreeProgramme:
              DegreeProgrammeEntity.fromJson(applicant['degree_programmes']),
          userPreference:
              PreferenceEntity(skillsInterests: skills, categories: categories),
          userExperiences: experiences,
          userAccomplishments: accomplishments);

      applicants.add(TeamApplicantEntity(
          applicant['team_applicants'][0]['id'],
          applicant['team_applicants'][0]['status'],
          user,
          applicant['team_applicants'][0]['team_id']));
    }

    return applicants;
  }
}
