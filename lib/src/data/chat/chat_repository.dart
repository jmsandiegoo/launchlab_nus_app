import 'dart:async';

import 'package:launchlab/src/domain/chat/models/chat_message_entity.dart';
import 'package:launchlab/src/domain/chat/models/team_chat_entity.dart';
import 'package:launchlab/src/domain/chat/repositories/chat_repository_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatRepository implements ChatRepositoryImpl {
  final Supabase _supabase;
  ChatRepository(this._supabase);

  StreamSubscription<List<Map<String, dynamic>>>? _teamChatsSub;
  final Map<String, StreamSubscription<List<Map<String, dynamic>>>>
      _teamChatMessagesSubs = {};

  /// realtime functions
  // subscibe to messages for a particular chat message only onChanges
  void subscribeToTeamChatMessages(String chatId) {
    _supabase.client.channel('');

    var streamBuilder = _supabase.client
        .from("team_chat_messages")
        .stream(primaryKey: ["id"]).eq("chat_id", chatId);

    _teamChatMessagesSubs[chatId] =
        streamBuilder.listen((List<Map<String, dynamic>> data) {
      print("Team Chat Messages: $data");
    });
  }

  void stopListenToTeamChatMessages({required String chatId}) {
    _teamChatMessagesSubs[chatId]?.cancel();
    _teamChatMessagesSubs.remove(chatId);
  }

  // non-realtime functions
  Future<List<TeamChatEntity>> getTeamChatsByTeamId(
      {required String teamId}) async {
    // fetch team chats
    final List<Map<String, dynamic>> res = await _supabase.client
        .from("team_chats")
        .select<PostgrestList>(
            "*, messages:team_chat_messages(*), chat_users:team_chat_users(*)")
        .eq("team_id", teamId)
        .order('created_at', foreignTable: "team_chat_messages")
        .limit(1, foreignTable: 'team_chat_messages');

    List<TeamChatEntity> teamChats =
        res.map((item) => TeamChatEntity.fromJson(item)).toList();
    return teamChats;
  }

  Future<List<ChatMessageEntity>> getTeamChatMessagesByChatId(
      {required String chatId}) async {
    // paginate later
    final List<Map<String, dynamic>> res = await _supabase.client
        .from("team_chat_messages")
        .select("*, seens:team_message_seens(*)")
        .eq(
          "chat_id",
          chatId,
        )
        .order("created_at");

    List<ChatMessageEntity> teamChatMessages = [];

    for (int i = 0; i < res.length; i++) {
      teamChatMessages.add(ChatMessageEntity.fromJson(res[i]));
    }

    return teamChatMessages;
  }

  // listen to message seens for a particular message

  // listen to team users if not there remove the direct chat

  // listen to events

  // listen to message seens
}
