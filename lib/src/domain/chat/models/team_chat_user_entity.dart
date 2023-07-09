import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';

class TeamChatUserEntity extends Equatable {
  const TeamChatUserEntity({
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
