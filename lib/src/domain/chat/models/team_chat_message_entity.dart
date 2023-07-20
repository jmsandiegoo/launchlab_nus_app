import 'package:equatable/equatable.dart';

class TeamChatMessageEntity extends Equatable {
  const TeamChatMessageEntity({
    required this.id,
    required this.messageContent,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String messageContent;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [];
}
