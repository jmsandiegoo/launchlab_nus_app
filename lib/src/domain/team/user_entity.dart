import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity(
      this.id,
      this.firstName,
      this.lastName,
      this.title,
      this.about,
      this.degree,
      this.avatar,
      this.avatarURL,
      this.resume,
      this.applicantId);

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        title,
        about,
        degree,
        avatar,
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
  final String? avatar;
  final String avatarURL;
  final String? resume;
  final String applicantId;

  UserEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        title = json['title'],
        about = json['about'],
        degree = '',
        avatar = json['avatar'],
        avatarURL = json['avatar_url'],
        resume = json['resume'],
        applicantId = '';

  UserEntity.fromApplicantJson(Map<String, dynamic> json)
      : id = json['id'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        title = json['title'],
        about = json['about'],
        //degree = json['degree_programmes']['name'],
        degree = '',
        avatar = json['avatar'],
        avatarURL = json['avatar_url'],
        resume = json['resume'],
        applicantId = '';

  UserEntity.fromManageTeamJson(Map<String, dynamic> json)
      : id = json['id'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        title = json['title'],
        about = json['about'],
        degree = '',
        avatar = json['avatar'],
        avatarURL = json['avatar_url'],
        resume = json['resume'],
        applicantId = json['team_applicants'][0]['id'];

  String getFullName() {
    return '$firstName $lastName';
  }
}
