import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/chat/models/chat_message_entity.dart';
import 'package:launchlab/src/domain/chat/models/chat_user_entity.dart';

abstract class ChatEntity extends Equatable {
  const ChatEntity({
    required this.id,
    this.unreads = 0,
    this.createdAt,
    this.updatedAt,
    this.chatMessages = const [],
    this.chatUsers = const [],
  });

  final String id;
  final int unreads;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final List<ChatMessageEntity> chatMessages;
  final List<ChatUserEntity> chatUsers;

  String? getChatName({required String currUserId});

  ChatMessageEntity? getLatestMessage();

  String? getChatAvatarUrl({required String currUserId});

  ChatEntity setChatUsers({required List<ChatUserEntity> chatUsers});
}
