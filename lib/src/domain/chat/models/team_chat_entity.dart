import 'package:launchlab/src/domain/chat/models/chat_message_entity.dart';
import 'package:launchlab/src/domain/chat/models/chat_user_entity.dart';
import 'package:launchlab/src/domain/chat/models/chat_entity.dart';
import 'package:launchlab/src/domain/team/team_entity.dart';
import 'package:launchlab/src/domain/team/team_user_entity.dart';

class TeamChatEntity extends ChatEntity implements Comparable<TeamChatEntity> {
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

  bool checkIfChatForUser(String currUserId, List<TeamUserEntity> users) {
    if (isGroupChat) {
      return true;
    }

    bool isCurrUser = false;
    bool isOtherUsersExist = false;

    for (int i = 0; i < chatUsers.length; i++) {
      // check if current user
      if (chatUsers[i].checkIfCurrentUser(currUserId: currUserId)) {
        isCurrUser = true;
        continue;
      }

      for (int j = 0; j < users.length; j++) {
        if (chatUsers[i].checkIfSameUserId(userId: users[j].userId)) {
          isOtherUsersExist = true;
          break;
        }
      }

      if (isCurrUser && isOtherUsersExist) {
        break;
      }
    }

    return isCurrUser && isOtherUsersExist;
  }

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
        if (!chatUsers[i].checkIfCurrentUser(currUserId: currUserId)) {
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

  @override
  int compareTo(TeamChatEntity other) {
    if (this == other) {
      return 0;
    }

    // check if group chat
    if (isGroupChat && !other.isGroupChat) {
      return -1;
    }

    if (!isGroupChat && other.isGroupChat) {
      return 1;
    }

    // compare messages
    if (chatMessages.isNotEmpty && other.chatMessages.isEmpty) {
      return -1;
    }

    if (chatMessages.isEmpty && other.chatMessages.isNotEmpty) {
      return 1;
    }

    if (chatMessages.isNotEmpty && other.chatMessages.isNotEmpty) {
      int res = getLatestMessage()!
          .createdAt!
          .compareTo(other.getLatestMessage()!.createdAt!);

      return res < 0
          ? 1
          : res > 0
              ? -1
              : 0;
    }

    return 0;
  }

  TeamChatEntity setTeam({required TeamEntity team}) {
    return TeamChatEntity(
      id: id,
      isGroupChat: isGroupChat,
      teamId: teamId,
      chatUsers: chatUsers,
      chatMessages: chatMessages,
      team: team,
      createdAt: createdAt,
      updatedAt: createdAt,
    );
  }

  @override
  TeamChatEntity updateMessage(
      {required int index, required ChatMessageEntity updatedMessage}) {
    List<ChatMessageEntity> messages = [...chatMessages];

    messages[index] = updatedMessage;

    return TeamChatEntity(
      id: id,
      isGroupChat: isGroupChat,
      teamId: teamId,
      chatMessages: [...messages],
      chatUsers: chatUsers,
      team: team,
      createdAt: createdAt,
      updatedAt: createdAt,
    );
  }

  @override
  TeamChatEntity appendMessages({required List<ChatMessageEntity> messages}) {
    return TeamChatEntity(
      id: id,
      isGroupChat: isGroupChat,
      teamId: teamId,
      chatMessages: [...chatMessages, ...messages],
      chatUsers: chatUsers,
      team: team,
      createdAt: createdAt,
      updatedAt: createdAt,
    );
  }

  @override
  TeamChatEntity setMessages({required List<ChatMessageEntity> messages}) {
    return TeamChatEntity(
      id: id,
      isGroupChat: isGroupChat,
      teamId: teamId,
      chatMessages: messages,
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
      chatMessages: chatMessages,
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
