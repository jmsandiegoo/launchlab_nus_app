import 'package:equatable/equatable.dart';

class UserTeamEntity extends Equatable {
  const UserTeamEntity(this.id, this.firstName, this.lastName, this.title,
      this.about, this.degree, this.avatarURL, this.resume, this.applicantId);

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        title,
        about,
        degree,
        avatarURL,
        resume,
        applicantId
      ];

  final String id;
  final String firstName;
  final String lastName;
  final String title;
  final String about;
  final String degree;
  final String avatarURL;
  final String? resume;
  final String applicantId;

  UserTeamEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        title = json['title'],
        about = json['about'],
        degree = '',
        avatarURL = '',
        resume = json['resume'],
        applicantId = '';

  UserTeamEntity.fromApplicantJson(Map<String, dynamic> json)
      : id = json['id'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        title = json['title'],
        about = json['about'],
        degree = json['degree_programmes']['name'],
        avatarURL = '',
        resume = json['resume'],
        applicantId = '';

  UserTeamEntity.fromManageTeamJson(Map<String, dynamic> json)
      : id = json['id'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        title = json['title'],
        about = json['about'],
        degree = '',
        avatarURL = '',
        resume = json['resume'],
        applicantId = json['team_applicants'][0]['id'];

  String getFullName() {
    return '$firstName $lastName';
  }
}
