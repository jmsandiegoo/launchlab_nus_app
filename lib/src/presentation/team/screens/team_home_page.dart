import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/data/authentication/repository/auth_repository.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/team/cubits/team_home_cubit.dart';
import 'package:launchlab/src/presentation/team/widgets/team_home_item.dart';
import 'package:launchlab/src/presentation/team/widgets/team_home_header.dart';
import 'package:launchlab/src/presentation/team/widgets/team_home_leading_list.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeamHomePage extends StatelessWidget {
  const TeamHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TeamHomeCubit(AuthRepository(Supabase.instance),
          TeamRepository(), UserRepository(Supabase.instance)),
      child: const TeamHomeContent(),
    );
  }
}

class TeamHomeContent extends StatefulWidget {
  const TeamHomeContent({super.key});

  @override
  State<TeamHomeContent> createState() => _TeamHomeState();
}

class _TeamHomeState extends State<TeamHomeContent> {
  late TeamHomeCubit teamHomeCubit;

  @override
  void initState() {
    super.initState();
    teamHomeCubit = BlocProvider.of<TeamHomeCubit>(context);
    teamHomeCubit.getData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamHomeCubit, TeamHomeState>(builder: (context, state) {
      return RefreshIndicator(
          onRefresh: () async {
            refreshPage();
          },
          child: state.status == TeamHomeStatus.success
              ? Scaffold(
                  backgroundColor: lightGreyColor,
                  body: ListView(padding: EdgeInsets.zero, children: [
                    Column(children: [
                      const TeamHomeHeader(),
                      const SizedBox(height: 15),
                      //Team Cards
                      state.isLeading ? const TeamHomeLeadingList() : Container()
                        
                      // if (teamHomeCubit.state.isLeading) ...[
                      //   teamHomeCubit.state.ownerTeamData.isEmpty
                      //       ? Column(children: [
                      //           const SizedBox(height: 150),
                      //           headerText("Uh oh. \nNo Leading Teams Found!",
                      //               alignment: TextAlign.center)
                      //         ])
                      //       : Column(children: [
                      //           for (int i = 0;
                      //               i <
                      //                   teamHomeCubit
                      //                       .state.ownerTeamData.length;
                      //               i++) ...[
                      //             const SizedBox(height: 20),
                      //             GestureDetector(
                      //                 onTap: () {
                      //                   navigatePushWithData(
                      //                       context, "/team-home/teams", [
                      //                     teamHomeCubit
                      //                         .state.ownerTeamData[i].id,
                      //                     true
                      //                   ]).then((value) {
                      //                     if (value?.actionType ==
                      //                         ActionTypes.update) {
                      //                       refreshPage();
                      //                     }
                      //                   });
                      //                 },
                      //                 child: TeamHomeItem(
                      //                     teamData: teamHomeCubit
                      //                         .state.ownerTeamData[i]))
                      //           ],
                      //         ])
                      // ] else ...[
                      //   teamHomeCubit.state.memberTeamData.isEmpty
                      //       ? Column(children: [
                      //           const SizedBox(height: 150),
                      //           headerText(
                      //               "Uh oh. \nNo Participating Teams Found!",
                      //               alignment: TextAlign.center),
                      //           ElevatedButton(
                      //               onPressed: () {
                      //                 navigateGo(context, "/discover");
                      //               },
                      //               child: smallText("  Search Teams  ")),
                      //         ])
                      //       : Column(children: [
                      //           for (int i = 0;
                      //               i < state.memberTeamData.length;
                      //               i++) ...[
                      //             const SizedBox(height: 20),
                      //             GestureDetector(
                      //                 onTap: () {
                      //                   navigatePushWithData(
                      //                       context, "/team-home/teams", [
                      //                     state.memberTeamData[i].id,
                      //                     false
                      //                   ]).then((value) {
                      //                     if (value?.actionType ==
                      //                         ActionTypes.update) {
                      //                       refreshPage();
                      //                     }
                      //                   });
                      //                 },
                      //                 child: TeamHomeItem(
                      //                     teamData: state.memberTeamData[i]))
                      //           ],
                      //         ])
                      // ],
                    ]),
                  ]),
                )
              : const Center(child: CircularProgressIndicator()));
    });
  }

  void refreshPage() {
    teamHomeCubit.loading();
    teamHomeCubit.getData();
  }
}
