import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/chat/models/chat_message_entity.dart';
import 'package:launchlab/src/presentation/common/cubits/app_root_cubit.dart';
import 'package:launchlab/src/presentation/common/widgets/text/ll_body_text.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/utils/extensions.dart';
import 'package:launchlab/src/utils/helper.dart';

class ChatBody extends StatefulWidget {
  const ChatBody({
    super.key,
    required this.chatMessages,
  });

  final List<ChatMessageEntity> chatMessages;

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  late AppRootCubit _appRootCubit;

  @override
  void initState() {
    super.initState();
    _appRootCubit = BlocProvider.of<AppRootCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.chatMessages.isEmpty) {
      return const Center(
        child: Text("No messages yet"),
      );
    }

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          reverse: true,
          children: [
            const SizedBox(
              height: 20.0,
            ),
            ...() {
              List<Widget> chatBubbles = [];

              for (int i = widget.chatMessages.length - 1; i >= 0; i--) {
                final message = widget.chatMessages[i];

                DateTime tmpDate;
                bool isShowDateSeparator = false;
                int nextIndex = i - 1;

                if (nextIndex < 0) {
                  isShowDateSeparator = true;
                } else {
                  tmpDate = widget.chatMessages[i - 1].createdAt!;
                  isShowDateSeparator = !tmpDate.isSameDate(message.createdAt!);
                }

                chatBubbles.add(ChatBubble(
                  message: message,
                  isSenderCurrUser: message.checkIfSenderIsCurrUser(
                      _appRootCubit.state.authUserProfile!.id!),
                  isShowDateSeparator: isShowDateSeparator,
                ));
              }
              return chatBubbles;
            }(),
          ],
        ));
  }
}

class DateSeparator extends StatelessWidget {
  const DateSeparator({
    super.key,
    required this.dateTime,
  });

  final DateTime dateTime;

  String _generateDate() {
    // Today
    final DateTime localDateTime = dateTime.toLocal();
    final DateTime today = DateTime.now();

    String dateString;

    if (localDateTime.isSameDate(today.subtract(const Duration(days: 1)))) {
      dateString = "Yesterday";
    } else if (dateTime.toLocal().isSameDate(today)) {
      dateString = "Today";
    } else {
      dateString = dateStringFormatter(
          localDateTime.isSameYear(today) ? "MMM d (EEE)" : "MMM d yyyy (EEE)",
          localDateTime);
    }

    return dateString;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Center(child: LLBodyText(label: _generateDate())),
    );
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    this.isSenderCurrUser = false,
    this.isShowDateSeparator = false,
  });

  final ChatMessageEntity message;
  final bool isSenderCurrUser;
  final bool isShowDateSeparator;

  @override
  Widget build(BuildContext context) {
    final AppRootCubit appRootCubit = BlocProvider.of<AppRootCubit>(context);
    return Column(
      children: [
        if (isShowDateSeparator) DateSeparator(dateTime: message.createdAt!),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            textDirection:
                isSenderCurrUser ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Expanded(
                  flex: isSenderCurrUser ? 6 : 3,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ...() {
                        if (isSenderCurrUser) {
                          return [];
                        }

                        return [
                          profilePicture(
                              35.0,
                              message.user?.userAvatar?.signedUrl != null
                                  ? message.user!.userAvatar!.signedUrl!
                                  : "avatar_temp.png",
                              isUrl:
                                  message.user?.userAvatar?.signedUrl != null),
                          const SizedBox(
                            width: 15.0,
                          ),
                        ];
                      }(),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color:
                                  isSenderCurrUser ? yellowColor : whiteColor),
                          child: Column(
                            children: [
                              ...() {
                                if (isSenderCurrUser) {
                                  return [];
                                }

                                return [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: smallText(
                                          message.getSenderName(appRootCubit
                                                  .state
                                                  .authUserProfile!
                                                  .id!) ??
                                              '',
                                          weight: FontWeight.bold,
                                          maxLines: 2,
                                        ),
                                      )
                                    ],
                                  )
                                ];
                              }(),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: smallText(
                                      message.messageContent,
                                      overflow: null,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ...() {
                                    if (!isSenderCurrUser ||
                                        message.chatMessageStatus ==
                                            ChatMessageStatus.error) {
                                      return [];
                                    }

                                    return [
                                      Image.asset(
                                          width: 16.0,
                                          height: 16.0,
                                          "assets/images/${message.chatMessageStatus == ChatMessageStatus.sending ? "message_sending.png" : "message_sent.png"}")
                                    ];
                                  }(),
                                  const SizedBox(width: 2.0),
                                  smallText(
                                      dateStringFormatter(
                                          "hh:mm a", message.createdAt!),
                                      color: greyColor.shade700),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      ...() {
                        if (!isSenderCurrUser ||
                            message.chatMessageStatus !=
                                ChatMessageStatus.error) {
                          return [];
                        }

                        return [
                          const SizedBox(width: 3.0),
                          const Icon(Icons.error_outline, color: errorColor),
                        ];
                      }(),
                    ],
                  )),
              Expanded(flex: isSenderCurrUser ? 4 : 1, child: Container()),
            ],
          ),
        )
      ],
    );
  }
}
