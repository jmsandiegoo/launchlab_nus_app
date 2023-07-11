import 'package:launchlab/src/domain/chat/models/chat_message_entity.dart';
import 'package:launchlab/src/domain/chat/models/chat_user_entity.dart';
import 'package:launchlab/src/domain/chat/models/chat_entity.dart';
import 'package:launchlab/src/domain/team/team_entity.dart';

class TeamChatEntity extends ChatEntity {
  const TeamChatEntity({
    required String id,
    int unreads = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
    required this.isGroupChat,
    required this.teamId,
    List<ChatMessageEntity> chatMessages = const [],
    List<ChatUserEntity> chatUsers = const [],
    this.team,
  }) : super(
          id: id,
          unreads: unreads,
          createdAt: createdAt,
          updatedAt: updatedAt,
          chatMessages: chatMessages,
          chatUsers: chatUsers,
        );

  final bool isGroupChat;
  final String teamId;

  // realtional objects
  final TeamEntity? team;

  @override
  ChatMessageEntity? getLatestMessage() {
    if (chatMessages.isEmpty) {
      return null;
    }

    return chatMessages[chatMessages.length - 1];
  }

  @override
  String? getChatName({required String currUserId}) {
    if (team == null || chatUsers.isEmpty) {
      return null;
    }

    if (isGroupChat) {
      return team!.teamName;
    } else {
      for (int i = 0; i < chatUsers.length; i++) {
        if (!chatUsers[i].isCurrentUser(currUserId: currUserId)) {
          return chatUsers[i].user?.getFullName();
        }
      }

      return null;
    }
  }

  @override
  String? getChatAvatarUrl({required String currUserId}) {
    if (team == null || chatUsers.isEmpty) {
      return null;
    }

    if (isGroupChat) {
      return team!.avatarURL != '' ? team!.avatarURL : null;
    } else {
      for (int i = 0; i < chatUsers.length; i++) {
        if (chatUsers[i].userId != currUserId) {
          return chatUsers[i].user?.userAvatar?.signedUrl;
        }
      }

      return null;
    }
  }

  TeamChatEntity setTeam({required TeamEntity team}) {
    return TeamChatEntity(
      id: id,
      isGroupChat: isGroupChat,
      teamId: teamId,
      chatUsers: chatUsers,
      team: team,
      createdAt: createdAt,
      updatedAt: createdAt,
    );
  }

  @override
  TeamChatEntity setChatUsers({required List<ChatUserEntity> chatUsers}) {
    return TeamChatEntity(
      id: id,
      isGroupChat: isGroupChat,
      teamId: teamId,
      chatUsers: chatUsers,
      team: team,
      createdAt: createdAt,
      updatedAt: createdAt,
    );
  }

  TeamChatEntity.fromJson(Map<String, dynamic> json)
      : isGroupChat = json["is_group_chat"],
        teamId = json["team_id"],
        team = json["team"] != null ? TeamEntity.fromJson(json["team"]) : null,
        super(
          id: json["id"],
          unreads: 0,
          createdAt: DateTime.tryParse(json["created_at"].toString()),
          updatedAt: DateTime.tryParse(json["updated_at"].toString()),
          chatMessages: (json["messages"]
                      ?.map((item) => ChatMessageEntity.fromJson(item))
                      .toList() ??
                  [])
              .cast<ChatMessageEntity>(),
          chatUsers: (json["chat_users"]
                      ?.map((item) => ChatUserEntity.fromJson(item))
                      .toList() ??
                  [])
              .cast<ChatUserEntity>(),
        );

  @override
  List<Object?> get props => [
        id,
        unreads,
        isGroupChat,
        createdAt,
        updatedAt,
        teamId,
        team,
        chatMessages,
        chatUsers,
      ];
}
