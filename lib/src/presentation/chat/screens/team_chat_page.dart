import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/chat/chat_repository.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/presentation/chat/cubits/chats_container_cubit.dart';
import 'package:launchlab/src/presentation/chat/cubits/team_chat_page_cubit.dart';
import 'package:launchlab/src/presentation/chat/widgets/chat_body.dart';
import 'package:launchlab/src/presentation/chat/widgets/chat_message_bar.dart';
import 'package:launchlab/src/presentation/chat/widgets/team_chat_page_header.dart';
import 'package:launchlab/src/presentation/common/cubits/app_root_cubit.dart';
import 'package:launchlab/src/utils/helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeamChatPage extends StatelessWidget {
  const TeamChatPage({super.key, required this.chatId});

  final String chatId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TeamChatPageCubit(
          teamRepository: TeamRepository(),
          chatRepository: ChatRepository(Supabase.instance),
          userRepository: UserRepository(Supabase.instance)),
      child: TeamChatContent(
        chatId: chatId,
      ),
    );
  }
}

class TeamChatContent extends StatefulWidget {
  const TeamChatContent({
    super.key,
    required this.chatId,
  });

  final String chatId;

  @override
  State<TeamChatContent> createState() => _TeamChatContentState();
}

class _TeamChatContentState extends State<TeamChatContent> {
  late AppRootCubit _appRootCubit;
  late TeamChatPageCubit _teamChatPageCubit;
  late ChatsContainerCubit _chatsContainerCubit;

  @override
  void initState() {
    super.initState();
    _appRootCubit = BlocProvider.of<AppRootCubit>(context);
    _teamChatPageCubit = BlocProvider.of<TeamChatPageCubit>(context);
    _chatsContainerCubit = BlocProvider.of<ChatsContainerCubit>(context);
    _teamChatPageCubit.handleInitializePage(
        widget.chatId, _appRootCubit.state.authUserProfile!.id!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeamChatPageCubit, TeamChatPageState>(
      listener: (context, state) {
        bool isUserInTeam = false;

        for (int i = 0; i < state.teamUsers.length; i++) {
          if (state.teamUsers[i].userId ==
              _appRootCubit.state.authUserProfile!.id!) {
            isUserInTeam = true;
            break;
          }
        }

        if (!isUserInTeam) {
          _chatsContainerCubit.setTeamId(null);
          navigateGo(context, "/chats");
        }
      },
      listenWhen: (previous, current) =>
          current.teamUsers != previous.teamUsers,
      builder: (context, state) {
        return Scaffold(
          body: () {
            if (state.teamChatPageStatus == TeamChatPageStatus.initial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Column(children: [
              TeamChatPageHeader(
                chat: state.teamChat,
                teamUsers: state.teamUsers,
              ),
              Expanded(
                child: ChatBody(
                  chatMessages: state.teamChat?.chatMessages ?? [],
                ),
              ),
              ChatMessageBar(
                messageDraft: state.newMessageInput.value,
                onChangedHandler: (val) =>
                    _teamChatPageCubit.onNewMessageChanged(val),
                onSubmitHandler: () => _teamChatPageCubit.handleSubmitMessage(
                    _appRootCubit.state.authUserProfile!.id!),
              ),
            ]);
          }(),
        );
      },
    );
  }
}
