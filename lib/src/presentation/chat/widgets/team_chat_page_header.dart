import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/chat/models/team_chat_entity.dart';
import 'package:launchlab/src/domain/team/team_user_entity.dart';
import 'package:launchlab/src/presentation/common/cubits/app_root_cubit.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

import 'package:launchlab/src/utils/helper.dart';

class TeamChatPageHeader extends StatelessWidget {
  const TeamChatPageHeader({
    super.key,
    required this.chat,
    required this.teamUsers,
  });

  final TeamChatEntity? chat;
  final List<TeamUserEntity> teamUsers;

  @override
  Widget build(BuildContext context) {
    if (chat == null) return const SizedBox.shrink();

    AppRootCubit appRootCubit = BlocProvider.of<AppRootCubit>(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      decoration: const BoxDecoration(color: yellowColor),
      child: SafeArea(
        top: true,
        bottom: false,
        child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            GestureDetector(
                onTap: () {
                  navigatePop(context);
                },
                child: const Icon(Icons.keyboard_backspace_outlined)),
            teamPicture(
                40.0,
                chat!.team!.avatarURL != ''
                    ? chat!.team!.avatarURL
                    : "team_avatar_temp.png"),
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
                    ((chat!.isGroupChat)
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    headerText(
                        "${chat?.getChatName(currUserId: appRootCubit.state.authUserProfile!.id!)}"),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: subHeaderText(
                            () {
                              String res = chat!.team!.teamName;
                              return res;
                            }(),
                            color: greyColor.shade700,
                            size: 15.0,
                            weight: FontWeight.w400,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    ...() {
                      if (chat!.isGroupChat) {
                        return [];
                      }

                      TeamUserEntity teamUser = teamUsers.firstWhere((user) =>
                          user.userId ==
                          chat!.getDirectChatUserId(
                              currUserId:
                                  appRootCubit.state.authUserProfile!.id!));

                      return [
                        Row(
                          children: [
                            Expanded(
                                child: subHeaderText(
                              "(${teamUser.positon})",
                              color: greyColor.shade700,
                              size: 15.0,
                              weight: FontWeight.w400,
                              maxLines: 1,
                            ))
                          ],
                        )
                      ];
                    }(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
        ],
      )),
    );
  }
}
