import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';

class MessageSeenEntity extends Equatable {
  const MessageSeenEntity({
    this.id,
    required this.messageId,
    required this.userId,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  final String? id;
  final String messageId;
  final String userId;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  // relationship objects
  final UserEntity? user;

  MessageSeenEntity.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        messageId = json["message_id"],
        userId = json["user_id"],
        createdAt = DateTime.tryParse(json['created_at'].toString()),
        updatedAt = DateTime.tryParse(json['updated_at'].toString()),
        user = json["user"] != null ? UserEntity.fromJson(json["user"]) : null;

  @override
  List<Object?> get props => [
        id,
        messageId,
        userId,
        createdAt,
        updatedAt,
        user,
      ];
}
