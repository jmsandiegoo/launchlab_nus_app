import 'dart:async';

import 'package:launchlab/src/domain/chat/repositories/chat_repository_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatRepository implements ChatRepositoryImpl {
  final Supabase _supabase;
  ChatRepository(this._supabase);

  StreamSubscription<List<Map<String, dynamic>>>? _teamChatsSub;
  final Map<String, StreamSubscription<List<Map<String, dynamic>>>>
      _teamChatMessagesSubs = {};

  // listen to team chats;
  void listenToTeamChats(
      {required String eqId, required void Function() streamHandler}) {
    _teamChatsSub = _supabase.client
        .from("team_chats")
        .stream(primaryKey: ["id"])
        .eq("id", eqId)
        .listen((List<Map<String, dynamic>> data) {
          print(data);
          streamHandler();
        });
  }

  void stopListenToTeamChats() {
    _teamChatsSub?.cancel();
  }

  // listen to messages for a particular chat message
  void listenToTeamChatMessages(String eqId) {
    var streamBuilder = _supabase.client
        .from("team_chats")
        .stream(primaryKey: ["id"]).eq("id", eqId);

    _teamChatMessagesSubs[eqId] =
        streamBuilder.listen((List<Map<String, dynamic>> data) {});
  }

  void stopListenToTeamChatMessages({required String eqId}) {
    _teamChatMessagesSubs[eqId]?.cancel();
    _teamChatMessagesSubs.remove(eqId);
  }

  // listen to message seens for a particular message

  // listen to team users if not there remove the direct chat

  // listen to events

  // listen to message seens
}
