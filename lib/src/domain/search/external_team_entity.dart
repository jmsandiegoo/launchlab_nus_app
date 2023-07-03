import 'package:equatable/equatable.dart';

class ExternalTeamEntity extends Equatable {
  const ExternalTeamEntity(
      this.id,
      this.teamName,
      this.description,
      this.currentMembers,
      this.maxMembers,
      this.startDate,
      this.endDate,
      this.commitment,
      this.category,
      this.interest,
      this.avatar,
      this.avatarURL,
      this.teamUser,
      this.rolesOpen);

  @override
  List<Object?> get props => [
        id,
        teamName,
        description,
        currentMembers,
        maxMembers,
        startDate,
        endDate,
        commitment,
        category,
        interest,
        avatar,
        avatarURL,
        teamUser,
        rolesOpen,
      ];

  final String id;
  final String teamName;
  final String description;
  final int currentMembers;
  final int maxMembers;
  final DateTime startDate;
  final DateTime? endDate;
  final String commitment;
  final String category;
  final List interest;
  final String? avatar;
  final String avatarURL;
  final List teamUser;
  final List rolesOpen;

  //Factory Method
  ExternalTeamEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        teamName = json['team_name'],
        description = json['description'],
        currentMembers = json['current_members'],
        maxMembers = json['max_members'],
        startDate = DateTime.parse(json['start_date']),
        endDate = DateTime.tryParse(json['end_date'].toString()),
        commitment = json['commitment'],
        category = json['project_category'],
        interest = json['interest'],
        avatar = json['avatar'],
        avatarURL = json['avatar_url'],
        teamUser = json['team_users'],
        rolesOpen = json['roles_open'];
}
