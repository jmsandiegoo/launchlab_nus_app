import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/chat/models/chat_entity.dart';
import 'package:launchlab/src/presentation/common/cubits/app_root_cubit.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({super.key, required this.chat});

  // Team Object
  final ChatEntity? chat;

  @override
  Widget build(BuildContext context) {
    AppRootCubit appRootCubit = BlocProvider.of<AppRootCubit>(context);
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: whiteColor,
        ),
        child: Row(children: [
          profilePicture(
            50.0,
            chat?.getChatAvatarUrl(
                    currUserId: appRootCubit.state.authUserProfile!.id!) ??
                "avatar_temp.png",
            isUrl: chat?.getChatAvatarUrl(
                        currUserId: appRootCubit.state.authUserProfile!.id!) !=
                    null
                ? true
                : false,
          ),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(
                  child: subHeaderText(
                      "${chat?.getChatName(currUserId: appRootCubit.state.authUserProfile!.id!)}",
                      size: 16.0,
                      maxLines: 1),
                ),
                smallText("10:00 AM"),
              ]),
              const SizedBox(
                height: 5.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        smallText("${chat?.getLatestMessage()?.userId ?? ''}",
                            weight: FontWeight.bold, maxLines: 1),
                        smallText(
                            "${chat?.getLatestMessage()?.messageContent ?? 'No messages yet'}",
                            alignment: TextAlign.left,
                            maxLines: 1),
                      ],
                    ),
                  ),
                  // const Badge(
                  //   backgroundColor: yellowColor,
                  //   textColor: blackColor,
                  //   label: Text("1"),
                  // )
                ],
              )
            ],
          ))
        ]),
      ),
    );
  }
}
