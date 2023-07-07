import 'package:equatable/equatable.dart';

class SearchTeamEntity extends Equatable {
  const SearchTeamEntity(
      this.id,
      this.teamName,
      this.description,
      this.currentMembers,
      this.maxMembers,
      this.commitment,
      this.category,
      this.interest,
      this.interestName,
      this.avatar,
      this.avatarURL,
      this.rolesOpen);

  @override
  List<Object?> get props => [
        id,
        teamName,
        description,
        currentMembers,
        maxMembers,
        commitment,
        category,
        interest,
        interestName,
        avatar,
        avatarURL,
        rolesOpen
      ];

  final String id;
  final String teamName;
  final String description;
  final int currentMembers;
  final int maxMembers;
  final String commitment;
  final String category;
  final List interest;
  final List interestName;
  final String? avatar;
  final String avatarURL;
  final List rolesOpen;

  SearchTeamEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        teamName = json['team_name'],
        description = json['description'],
        currentMembers = json['current_members'],
        maxMembers = json['max_members'],
        commitment = json['commitment'],
        category = json['project_category'],
        interest = json['interest'],
        interestName = json['interest_name'],
        avatar = json['avatar'],
        avatarURL = json['avatar_url'],
        rolesOpen = json['roles_open'];

  String getInterests() {
    String interests = interest[0]['name'];
    for (int i = 1; i < interest.length; i++) {
      interests += ', ${interest[i]['name']}';
    }
    return interests;
  }

  String getRoles() {
    String roles = '';
    for (int i = 0; i < rolesOpen.length; i++) {
      if (i == 0) {
        roles += rolesOpen[i]['title'];
      } else {
        roles += ', ${rolesOpen[i]['title']}';
      }
    }
    return roles;
  }

  compareTo(SearchTeamEntity a) {}
}
