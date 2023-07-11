import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/chat/models/message_seen_entity.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';

class ChatMessageEntity extends Equatable {
  const ChatMessageEntity({
    required this.id,
    required this.messageContent,
    this.createdAt,
    this.updatedAt,
    required this.userId,
    this.user,
    this.messageSeens = const [],
  });

  final String id;
  final String messageContent;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final String userId;

  // relational objects
  final UserEntity? user;
  final List<MessageSeenEntity> messageSeens;

  ChatMessageEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        messageContent = json['message_content'],
        userId = json['user_id'],
        createdAt = DateTime.tryParse(json['created_at'].toString()),
        updatedAt = DateTime.tryParse(json['updated_at'].toString()),
        user = json['user'] != null ? UserEntity.fromJson(json['user']) : null,
        messageSeens = (json['message_seens']
                    ?.map((item) => MessageSeenEntity.fromJson(item))
                    .toList() ??
                [])
            .cast<MessageSeenEntity>();

  @override
  List<Object?> get props => [
        id,
        messageContent,
        createdAt,
        updatedAt,
        userId,
        user,
      ];
}
