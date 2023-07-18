import 'dart:async';

import 'package:flutter/material.dart';
import 'package:launchlab/src/domain/chat/models/chat_message_entity.dart';
import 'package:launchlab/src/domain/chat/models/team_chat_entity.dart';
import 'package:launchlab/src/domain/chat/repositories/chat_repository_impl.dart';
import 'package:launchlab/src/utils/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatRepository implements ChatRepositoryImpl {
  final Supabase _supabase;
  ChatRepository(this._supabase);

  /// realtime functions
  // subscibe to messages for a particular chat message only onChanges
  @override
  RealtimeChannel subscribeToTeamChatMessages(
      {required FutureOr<void> Function(dynamic payload) streamHandler}) {
    RealtimeChannel channel = _supabase.client
        .channel("public:team_chat_messages_${DateTime.now()}")
        .on(
            RealtimeListenTypes.postgresChanges,
            ChannelFilter(
                event: "INSERT",
                schema: "*",
                table: "team_chat_messages"), ((payload, [ref]) {
      debugPrint('Change received: ${payload.toString()} refs: $ref');
      streamHandler(payload);
    }));

    channel.subscribe();

    return channel;
  }

  @override
  Future<void> unsubscribeToTeamChatMessages(RealtimeChannel channel) async {
    await _supabase.client.removeChannel(channel);
  }

  // non-realtime functions
  @override
  Future<List<TeamChatEntity>> getTeamChatsByTeamId(
      {required String teamId}) async {
    // fetch team chats
    final List<Map<String, dynamic>> res = await _supabase.client
        .from("team_chats")
        .select<PostgrestList>(
            "*, messages:team_chat_messages(*, user:users(*)), chat_users:team_chat_users(*)")
        .eq("team_id", teamId)
        .order('created_at', foreignTable: "team_chat_messages")
        .limit(1, foreignTable: 'team_chat_messages');

    List<TeamChatEntity> teamChats =
        res.map((item) => TeamChatEntity.fromJson(item)).toList();
    return teamChats;
  }

  @override
  Future<TeamChatEntity> getTeamChatByChatId({required String chatId}) async {
    try {
      final List<Map<String, dynamic>> res = await _supabase.client
          .from("team_chats")
          .select<PostgrestList>("*, chat_users:team_chat_users(*)")
          .eq('id', chatId);

      if (res.isEmpty) {
        throw Failure.request();
      }

      return TeamChatEntity.fromJson(res[0]);
    } on Failure catch (_) {
      rethrow;
    } on PostgrestException catch (error) {
      debugPrint("upload user resume postgre error: $error");
      throw Failure.request(code: error.code);
    } on Exception catch (error) {
      debugPrint("Upload user resume unexpected error: $error");
      throw Failure.unexpected();
    }
  }

  @override
  Future<List<ChatMessageEntity>> getTeamChatMessagesByChatId(
      {required String chatId}) async {
    // paginate later
    try {
      final List<Map<String, dynamic>> res = await _supabase.client
          .from("team_chat_messages")
          .select<PostgrestList>("*, seens:team_message_seens(*)")
          .eq(
            "chat_id",
            chatId,
          )
          .order("created_at", ascending: true);

      List<ChatMessageEntity> teamChatMessages = [];

      for (int i = 0; i < res.length; i++) {
        teamChatMessages.add(ChatMessageEntity.fromJson(res[i]));
      }

      return teamChatMessages;
    } on Failure catch (_) {
      rethrow;
    } on PostgrestException catch (error) {
      debugPrint("upload user resume postgre error: $error");
      throw Failure.request(code: error.code);
    } on Exception catch (error) {
      debugPrint("Upload user resume unexpected error: $error");
      throw Failure.unexpected();
    }
  }

  @override
  Future<void> submitMessage(ChatMessageEntity newMessage) async {
    try {
      await _supabase.client
          .from("team_chat_messages")
          .insert(newMessage.toJson());
    } on PostgrestException catch (error) {
      debugPrint("upload user resume postgre error: $error");
      throw Failure.request(code: error.code);
    } on Exception catch (error) {
      debugPrint("Upload user resume unexpected error: $error");
      throw Failure.unexpected();
    }
  }
}
