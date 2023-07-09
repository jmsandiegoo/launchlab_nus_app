import 'package:flutter/material.dart';
import 'package:launchlab/src/presentation/chat/widgets/chat_item.dart';

class TeamChatList extends StatelessWidget {
  const TeamChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ChatItem(),
      ],
    );
  }
}
