import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/team/accomplishment_entity.dart';
import 'package:launchlab/src/domain/team/experience_entity.dart';
import 'package:launchlab/src/domain/team/team_entity.dart';
import 'package:launchlab/src/domain/team/user_entity.dart';

class GetApplicantData extends Equatable {
  const GetApplicantData(
      this.applicant, this.team, this.experiences, this.accomplishments);

  final UserEntity applicant;
  final TeamEntity team;
  final List experiences;
  final List accomplishments;

  @override
  List<Object?> get props => [applicant, team, experiences, accomplishments];

  List<ExperienceTeamEntity> getAllExperience() {
    List<ExperienceTeamEntity> allExperiences = [];
    for (var experience in experiences) {
      allExperiences.add(ExperienceTeamEntity.fromJson(experience));
    }
    return allExperiences;
  }

  List<AccomplishmentTeamEntity> getAllAccomplishment() {
    List<AccomplishmentTeamEntity> allAccomplishment = [];
    for (var accomplishment in accomplishments) {
      allAccomplishment.add(AccomplishmentTeamEntity.fromJson(accomplishment));
    }
    return allAccomplishment;
  }
}
