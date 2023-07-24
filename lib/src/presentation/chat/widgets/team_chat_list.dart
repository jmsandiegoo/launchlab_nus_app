import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/presentation/chat/cubits/team_chats_page_cubit.dart';
import 'package:launchlab/src/presentation/chat/widgets/chat_item.dart';

class TeamChatList extends StatelessWidget {
  const TeamChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamChatsPageCubit, TeamChatsPageState>(
      builder: (context, state) {
        //TeamChatsPageCubit teamChatsPageCubit = BlocProvider.of<TeamChatsPageCubit>(context);

        return ListView(
          padding: EdgeInsets.zero,
          children: [
            ...state.teamChats.map((chat) => ChatItem(chat: chat)).toList()
          ],
        );
      },
    );
  }
}
