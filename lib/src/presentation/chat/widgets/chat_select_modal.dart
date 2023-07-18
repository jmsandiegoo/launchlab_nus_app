import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/domain/team/team_entity.dart';
import 'package:launchlab/src/presentation/chat/cubits/chat_select_modal_cubit.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/multi_button_select.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class ChatSelectModal extends StatefulWidget {
  const ChatSelectModal({
    super.key,
    required this.selectedTeam,
    required this.chatSelectedModalTab,
    required this.onNavigate,
    required this.onClose,
  });

  final TeamEntity selectedTeam;
  final ChatSelectModalTab chatSelectedModalTab;
  final void Function(String) onNavigate;
  final void Function() onClose;

  @override
  State<ChatSelectModal> createState() => _ChatSelectModalState();
}

class _ChatSelectModalState extends State<ChatSelectModal> {
  final _searchFocusNode = FocusNode();
  final _searchController = TextEditingController();

  @override
  dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final ChatSelectModalCubit chatSelectModalCubit = ChatSelectModalCubit(
            selectedTeam: widget.selectedTeam,
            teamRepository: TeamRepository(),
            chatSelectModalTab: widget.chatSelectedModalTab);

        if (widget.chatSelectedModalTab == ChatSelectModalTab.leading) {
          // call fetch leading teams
          chatSelectModalCubit.handleFetchLeadingTeams();
        } else {
          chatSelectModalCubit.handleFetchParticipatingTeams();
        }

        return chatSelectModalCubit;
      },
      child: BlocConsumer<ChatSelectModalCubit, ChatSelectModalState>(
        listener: (context, state) {
          if (state.chatSelectModalTab == ChatSelectModalTab.leading) {
            context.read<ChatSelectModalCubit>().handleFetchLeadingTeams();
          }

          if (state.chatSelectModalTab == ChatSelectModalTab.participating) {
            context
                .read<ChatSelectModalCubit>()
                .handleFetchParticipatingTeams();
          }
        },
        listenWhen: (previous, current) {
          return previous.chatSelectModalTab != current.chatSelectModalTab;
        },
        builder: (context, state) {
          return Material(
            child: Stack(
              children: [
                Image.asset("assets/images/chat_select_bg.png"),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Image.asset(
                              "assets/images/chat_select.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Icon(Icons.forum_outlined),
                                    subHeaderText(" Select Chats",
                                        alignment: TextAlign.right),
                                  ])),
                        ],
                      ),
                      TextFieldWidget(
                        focusNode: _searchFocusNode,
                        onChangedHandler: (value) => context
                            .read<ChatSelectModalCubit>()
                            .onSearchChanged(value),
                        label: "",
                        value: state.searchInput.value,
                        hint: "Search a Team",
                        controller: _searchController,
                      ),
                      MultiButtonSingleSelectWidget<String>(
                          itemRatio: (1 / .3),
                          value: state.chatSelectModalTab.text(),
                          options: [
                            ChatSelectModalTab.leading.text(),
                            ChatSelectModalTab.participating.text(),
                          ],
                          colNo: 3,
                          onPressHandler: (val) {
                            context
                                .read<ChatSelectModalCubit>()
                                .handleTabChange(ChatSelectModalTab.values
                                    .firstWhere((e) => e.text() == val));
                          }),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Expanded(
                        child: () {
                          // TOOD: check if loading
                          if (state.chatSelectModalStatus ==
                                  ChatSelectModalStatus.loading ||
                              state.chatSelectModalStatus ==
                                  ChatSelectModalStatus.initial) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state.chatSelectModalTab ==
                              ChatSelectModalTab.leading) {
                            if (state.leadingTeams.isEmpty) {
                              return Center(
                                child: bodyText(
                                  "No leading teams found",
                                  size: 15.0,
                                  color: blackColor,
                                ),
                              );
                            }

                            return ListView(
                              children: state.leadingTeams
                                  .map(
                                    (team) => TeamChatCard(
                                      team: team,
                                      isCurrentlySelected:
                                          team.id == widget.selectedTeam.id,
                                      onNavigate: widget.onNavigate,
                                      onClose: widget.onClose,
                                    ),
                                  )
                                  .toList(),
                            );
                          } else {
                            if (state.participatingTeams.isEmpty) {
                              return Center(
                                child: bodyText(
                                  "No participating teams found",
                                  size: 15.0,
                                  color: blackColor,
                                ),
                              );
                            }

                            return ListView(
                              children: state.participatingTeams
                                  .map(
                                    (team) => TeamChatCard(
                                      team: team,
                                      isCurrentlySelected:
                                          team.id == widget.selectedTeam.id,
                                      onNavigate: widget.onNavigate,
                                      onClose: widget.onClose,
                                    ),
                                  )
                                  .toList(),
                            );
                          }
                        }(),
                      ),
                      SizedBox(
                        width: 150,
                        child: outlinedButton(
                            label: "Close",
                            onPressedHandler: widget.onClose,
                            color: blackColor),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TeamChatCard extends StatelessWidget {
  const TeamChatCard({
    super.key,
    required this.team,
    required this.isCurrentlySelected,
    required this.onNavigate,
    required this.onClose,
  });

  final TeamEntity team;
  final bool isCurrentlySelected;
  final void Function(String) onNavigate;
  final void Function() onClose;

  @override
  Widget build(BuildContext context) {
    // Needs chats

    return GestureDetector(
      onTap: () {
        if (isCurrentlySelected) {
          onClose();
          return;
        }

        onNavigate(team.id);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        decoration: BoxDecoration(
            color: isCurrentlySelected ? blackColor : greyColor.shade200,
            borderRadius: BorderRadius.circular(10.0)),
        child: Row(
          children: [
            teamPicture(
              50.0,
              team.avatarURL != "" ? team.avatarURL : "team_avatar_temp.png",
              isUrl: team.avatarURL != "",
            ),
            const SizedBox(width: 14.0),
            Expanded(
              child: subHeaderText(
                team.teamName,
                size: 13.0,
                color: isCurrentlySelected ? yellowColor : blackColor,
              ),
            ),
            smallText(
              isCurrentlySelected ? "Selected" : "",
              color: isCurrentlySelected ? yellowColor : blackColor,
            )
          ],
        ),
      ),
    );
  }
}
