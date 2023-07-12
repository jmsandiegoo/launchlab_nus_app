import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/team/team_entity.dart';
import 'package:launchlab/src/domain/team/user_entity.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';

class GetApplicantData extends Equatable {
  const GetApplicantData(
      this.applicant, this.team, this.experiences, this.accomplishments);

  final UserTeamEntity applicant;
  final TeamEntity team;
  final List experiences;
  final List accomplishments;

  @override
  List<Object?> get props => [applicant, team, experiences, accomplishments];

  List<ExperienceEntity> getAllExperience() {
    List<ExperienceEntity> allExperiences = [];
    for (var experience in experiences) {
      allExperiences.add(ExperienceEntity.fromJson(experience));
    }
    return allExperiences;
  }

  List<AccomplishmentEntity> getAllAccomplishment() {
    List<AccomplishmentEntity> allAccomplishment = [];
    for (var accomplishment in accomplishments) {
      allAccomplishment.add(AccomplishmentEntity.fromJson(accomplishment));
    }
    return allAccomplishment;
  }
}
