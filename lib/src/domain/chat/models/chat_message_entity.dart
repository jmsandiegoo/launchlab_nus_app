import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/chat/models/message_seen_entity.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';

class ChatMessageEntity extends Equatable {
  const ChatMessageEntity({
    required this.id,
    required this.messageContent,
    this.createdAt,
    this.updatedAt,
    required this.chatId,
    required this.userId,
    required this.chatMessageStatus,
    this.user,
    this.messageSeens = const [],
  });

  final String id;
  final String messageContent;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final String chatId;
  final String userId;

  final ChatMessageStatus chatMessageStatus;

  // relational objects
  final UserEntity? user;
  final List<MessageSeenEntity> messageSeens;

  ChatMessageEntity setStatus({required ChatMessageStatus newStatus}) {
    return ChatMessageEntity(
      id: id,
      messageContent: messageContent,
      chatId: chatId,
      userId: userId,
      chatMessageStatus: newStatus,
      user: user,
      messageSeens: messageSeens,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  ChatMessageEntity setUser({required UserEntity? user}) {
    return ChatMessageEntity(
      id: id,
      messageContent: messageContent,
      chatId: chatId,
      userId: userId,
      chatMessageStatus: chatMessageStatus,
      user: user,
      messageSeens: messageSeens,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  ChatMessageEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        messageContent = json['message_content'],
        chatId = json['chat_id'],
        userId = json['user_id'],
        createdAt = DateTime.tryParse(json['created_at'].toString()),
        updatedAt = DateTime.tryParse(json['updated_at'].toString()),
        chatMessageStatus = ChatMessageStatus.sent,
        user = json['user'] != null ? UserEntity.fromJson(json['user']) : null,
        messageSeens = (json['message_seens']
                    ?.map((item) => MessageSeenEntity.fromJson(item))
                    .toList() ??
                [])
            .cast<MessageSeenEntity>();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message_content': messageContent,
      'chat_id': chatId,
      'user_id': userId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  bool checkIfSenderIsCurrUser(String currUserId) {
    return currUserId == userId;
  }

  String? getSenderName(String currUserId) {
    if (currUserId == userId) {
      return "Me";
    }

    return user?.getFullName();
  }

  @override
  List<Object?> get props => [
        id,
        messageContent,
        createdAt,
        updatedAt,
        chatId,
        userId,
        chatMessageStatus,
        user,
        messageSeens,
      ];
}

enum ChatMessageStatus {
  sent,
  sending,
  error,
}
