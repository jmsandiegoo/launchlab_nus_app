import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';

class ChatUserEntity extends Equatable {
  const ChatUserEntity({
    required this.id,
    required this.chatId,
    required this.userId,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  // team user
  final String id;
  final String chatId;
  final String userId;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  // relational object
  final UserEntity? user;

  bool isCurrentUser({required String currUserId}) {
    return userId == currUserId;
  }

  ChatUserEntity setUser({required UserEntity? user}) {
    return ChatUserEntity(
      id: id,
      chatId: chatId,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      user: user,
    );
  }

  ChatUserEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        chatId = json['chat_id'],
        userId = json['user_id'],
        createdAt = DateTime.tryParse(json['created_at'].toString()),
        updatedAt = DateTime.tryParse(json['updated_at'].toString()),
        user = json['user'] != null ? UserEntity.fromJson(json['user']) : null;

  @override
  List<Object?> get props => [
        id,
        chatId,
        userId,
        createdAt,
        updatedAt,
        user,
      ];
}
