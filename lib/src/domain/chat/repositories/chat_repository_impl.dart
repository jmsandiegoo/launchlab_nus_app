import 'dart:async';
import 'package:launchlab/src/domain/chat/models/chat_message_entity.dart';
import 'package:launchlab/src/domain/chat/models/team_chat_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ChatRepositoryImpl {
  RealtimeChannel subscribeToTeamChatMessages(
      {required FutureOr<void> Function(dynamic payload) streamHandler});

  Future<void> unsubscribeToTeamChatMessages(RealtimeChannel channel);

  Future<List<TeamChatEntity>> getTeamChatsByTeamId({required String teamId});

  Future<TeamChatEntity> getTeamChatByChatId({required String chatId});

  Future<List<ChatMessageEntity>> getTeamChatMessagesByChatId(
      {required String chatId});

  Future<void> submitMessage(ChatMessageEntity newMessage);
}
