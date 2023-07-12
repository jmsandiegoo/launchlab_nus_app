import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/chat/models/team_chat_message_entity.dart';
import 'package:launchlab/src/domain/chat/models/team_chat_user_entity.dart';

class TeamChatEntity extends Equatable {
  const TeamChatEntity({
    required this.id,
    required this.isGroupChat,
    this.createdAt,
    this.updatedAt,
    required this.teamId,
  });

  final String id;
  final bool isGroupChat;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final String teamId;

  @override
  List<Object?> get props => [];
}
