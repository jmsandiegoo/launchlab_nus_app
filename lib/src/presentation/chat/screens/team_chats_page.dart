import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/data/chat/chat_repository.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/presentation/chat/cubits/team_chats_page_cubit.dart';
import 'package:launchlab/src/presentation/chat/widgets/chat_select_modal.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/multi_button_select.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/utils/extensions.dart';
import 'package:launchlab/src/utils/helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeamChatsPage extends StatelessWidget {
  const TeamChatsPage({
    super.key,
    required this.teamId,
    required this.child,
  });

  final String teamId;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TeamChatsPageCubit(
          teamRepository: TeamRepository(),
          chatRepository: ChatRepository(Supabase.instance),
          userRepository: UserRepository(Supabase.instance)),
      child: TeamChatsContent(teamId: teamId, child: child),
    );
  }
}

class TeamChatsContent extends StatefulWidget {
  const TeamChatsContent({
    super.key,
    required this.teamId,
    required this.child,
  });

  final String teamId;
  final Widget child;

  @override
  State<TeamChatsContent> createState() => _TeamChatsContentState();
}

class _TeamChatsContentState extends State<TeamChatsContent> {
  late TeamChatsPageCubit _teamChatsPageCubit;

  @override
  void initState() {
    super.initState();
    _teamChatsPageCubit = BlocProvider.of<TeamChatsPageCubit>(context);
    _teamChatsPageCubit.handleInitializePage(widget.teamId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeamChatsPageCubit, TeamChatsPageState>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        body: () {
          if (state.teamChatsPageStatus == TeamChatsPageStatus.initial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                AppBar(
                  titleSpacing: 0,
                  centerTitle: false,
                  backgroundColor: Colors.transparent,
                  title: GestureDetector(
                    onTap: () => showDialog(
                        context: context,
                        builder: (context) {
                          return ChatSelectModal(
                            onClose: () => Navigator.pop(context),
                          );
                        }),
                    child: Container(
                        decoration: BoxDecoration(
                            color: yellowColor,
                            borderRadius: BorderRadius.circular(5.0)),
                        padding: const EdgeInsets.all(15.0),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          subHeaderText("${state.team?.teamName}", size: 15.0),
                          const Icon(
                            Icons.expand_more_outlined,
                            weight: 100,
                          )
                        ])),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          context.push(
                              "/profile/209b2b56-6156-42bc-91ee-4b20d5632ce3");
                        },
                        icon: const Icon(Icons.waving_hand_outlined)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.info_outline))
                  ],
                ),
                const SizedBox(
                  height: 50.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.chat_bubble_outline),
                    headerText("  Chats"),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFieldWidget(
                    focusNode: FocusNode(),
                    onChangedHandler: (val) {},
                    label: "",
                    value: "",
                    hint: "Search Chat",
                    controller: TextEditingController()),
                const SizedBox(
                  height: 10.0,
                ),
                MultiButtonSingleSelectWidget<String>(
                    itemRatio: (1 / .3),
                    value: () {
                      final locationList =
                          GoRouter.of(context).location.split('/');
                      return locationList[locationList.length - 1]
                          .toCapitalize();
                    }(),
                    options: const ["Team", "Requests", "Invites"],
                    colNo: 3,
                    onPressHandler: (val) {
                      navigateGo(context,
                          "/team-chats/${widget.teamId}/${val.toLowerCase()}");
                    }),
                Expanded(
                  child: widget.child,
                ),
              ],
            ),
          );
        }(),
      ),
    );
  }
}