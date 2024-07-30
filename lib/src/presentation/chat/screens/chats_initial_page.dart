import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/presentation/chat/cubits/chats_container_cubit.dart';
import 'package:launchlab/src/presentation/chat/cubits/chats_initial_page_cubit.dart';
import 'package:launchlab/src/presentation/common/widgets/text/ll_body_text.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/utils/helper.dart';

class ChatsInitialPage extends StatelessWidget {
  const ChatsInitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatsInitialPageCubit(
        teamRepository: TeamRepository(),
        teamId: context.read<ChatsContainerCubit>().state.teamId,
      ),
      child: const ChatsInitialContent(),
    );
  }
}

class ChatsInitialContent extends StatefulWidget {
  const ChatsInitialContent({super.key});

  @override
  State<ChatsInitialContent> createState() => _ChatsInitialContentState();
}

class _ChatsInitialContentState extends State<ChatsInitialContent> {
  late ChatsInitialPageCubit _chatsInitialPageCubit;

  @override
  void initState() {
    super.initState();
    _chatsInitialPageCubit = BlocProvider.of<ChatsInitialPageCubit>(context);
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _chatsInitialPageCubit.handleInitialPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatsInitialPageCubit, ChatsInitialPageState>(
      listener: (context, state) {
        debugPrint("hereeee: ${state.chatsInitialPageStatus}");

        if (state.chatsInitialPageStatus == ChatsInitialPageStatus.redirect) {
          navigateGo(context, '/team-chats/${state.teamId}/team');
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: () {
            if (state.chatsInitialPageStatus ==
                    ChatsInitialPageStatus.initial ||
                state.chatsInitialPageStatus ==
                    ChatsInitialPageStatus.redirect) {
              debugPrint("redirecting: ${state.chatsInitialPageStatus}");
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return SafeArea(
                top: true,
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.asset('assets/images/no_team_chats.png'),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                LLBodyText(
                    label: state.chatsInitialPageStatus == ChatsInitialPageStatus.empty
                        ? "Uh oh.... It seems that you don’t \n belong to any teams yet"
                        : "An error occured",
                    textAlign: TextAlign.center),
                const SizedBox(height: 15.0),
                Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 170.0),
                    width: double.infinity,
                    child: secondaryButton(
                      context,
                      () {
                        _chatsInitialPageCubit.handleInitialPage();
                      },
                      "Reload",
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ));
          }(),
        );
      },
    );
  }
}
