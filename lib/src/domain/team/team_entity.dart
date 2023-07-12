import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/chat/models/team_chat_entity.dart';

class TeamEntity extends Equatable {
  const TeamEntity(
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
    this.isListed,
    this.isCurrent,
    this.milestones,
  );

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
        isListed,
        isCurrent,
        interest,
        avatar,
        avatarURL,
        milestones,
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
  final bool isListed;
  final bool isCurrent;
  final List interest;
  final String? avatar;
  final String avatarURL;
  final List milestones;

  TeamEntity setTeamChats(
    List<TeamChatEntity> teamChats,
  ) {
    return TeamEntity(
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
      isListed,
      isCurrent,
      milestones,
    );
  }

  //Factory Method
  TeamEntity.fromTeamHomeJson(Map<String, dynamic> json)
      : id = json['id'],
        teamName = json['team_name'],
        description = json['description'],
        currentMembers = json['current_members'],
        maxMembers = json['max_members'],
        startDate = DateTime.parse(json['start_date']),
        endDate = DateTime.tryParse(json['end_date'].toString()),
        commitment = json['commitment'],
        isListed = json['is_listed'],
        isCurrent = json['is_current'],
        category = json['project_category'],
        interest = json['interest'],
        avatar = json['avatar'],
        avatarURL = json['avatar_url'],
        milestones = json['milestones'];

  TeamEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        teamName = json['team_name'],
        description = json['description'],
        currentMembers = json['current_members'],
        maxMembers = json['max_members'],
        startDate = DateTime.parse(json['start_date']),
        endDate = DateTime.tryParse(json['end_date'].toString()),
        commitment = json['commitment'],
        isListed = json['is_listed'],
        isCurrent = json['is_current'],
        category = json['project_category'],
        interest = json['interest'],
        avatar = json['avatar'],
        avatarURL = json['avatar_url'],
        milestones = [];

  int getMilestoneProgress() {
    int incompleteTask =
        milestones.where((map) => map['is_completed'] == false).length;
    int completedTask =
        milestones.where((map) => map['is_completed'] == true).length;

    return (incompleteTask + completedTask) == 0
        ? 0
        : (completedTask * 100 / (completedTask + incompleteTask)).round();
  }
}
