import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/chat/widgets/chat_body.dart';
import 'package:launchlab/src/presentation/chat/widgets/chat_message_bar.dart';
import 'package:launchlab/src/presentation/chat/widgets/chat_page_header.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/utils/helper.dart';

class TeamChatPage extends StatefulWidget {
  const TeamChatPage({
    super.key,
    required this.chatId,
  });

  final String? chatId;

  @override
  State<TeamChatPage> createState() => _TeamChatPageState();
}

class _TeamChatPageState extends State<TeamChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: () {
        return Column(children: [
          ChatPageHeader(),
          Expanded(
            child: ChatBody(),
          ),
          ChatMessageBar(),
        ]);
      }(),
    );
  }
}
