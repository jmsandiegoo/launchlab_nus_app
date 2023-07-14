import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/chat/models/chat_entity.dart';
import 'package:launchlab/src/domain/chat/models/team_chat_entity.dart';
import 'package:launchlab/src/presentation/common/cubits/app_root_cubit.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';

class ChatPageHeader extends StatelessWidget {
  const ChatPageHeader({
    super.key,
    required this.chat,
  });

  final ChatEntity? chat;

  @override
  Widget build(BuildContext context) {
    AppRootCubit appRootCubit = BlocProvider.of<AppRootCubit>(context);

    ChatTypes chatType =
        chat is TeamChatEntity ? ChatTypes.team : ChatTypes.request;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      decoration: const BoxDecoration(color: yellowColor),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            GestureDetector(
                onTap: () {
                  navigatePop(context);
                },
                child: const Icon(Icons.keyboard_backspace_outlined)),
            teamPicture(40.0, "team_avatar_temp.png"),
          ]),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              profilePicture(
                50.0,
                chat?.getChatAvatarUrl(
                        currUserId: appRootCubit.state.authUserProfile!.id!) ??
                    ((chatType == ChatTypes.team &&
                            (chat as TeamChatEntity).isGroupChat)
                        ? "team_avatar_temp.png"
                        : "avatar_temp.png"),
                isUrl: chat?.getChatAvatarUrl(
                            currUserId:
                                appRootCubit.state.authUserProfile!.id!) !=
                        null
                    ? true
                    : false,
              ),
              const SizedBox(
                width: 15.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headerText(
                      "${chat?.getChatName(currUserId: appRootCubit.state.authUserProfile!.id!)}"),
                  bodyText("Tech Lead", color: greyColor.shade700)
                ],
              )
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}
