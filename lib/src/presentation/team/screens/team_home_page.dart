import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/data/authentication/repository/auth_repository.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/team/cubits/team_home_cubit.dart';
import 'package:launchlab/src/presentation/team/widgets/team_home_card.dart';
import 'package:launchlab/src/utils/helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeamHome extends StatelessWidget {
  const TeamHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          TeamHomeCubit(AuthRepository(Supabase.instance), TeamRepository()),
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
    teamHomeCubit.initData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamHomeCubit, TeamHomeState>(builder: (context, state) {
      return teamHomeCubit.state.isLoaded == true
          ? Scaffold(
              backgroundColor: lightGreyColor,
              body: SingleChildScrollView(
                child: Column(children: [
                  Stack(
                    children: <Widget>[
                      Image.asset("assets/images/yellow_curve_shape_3.png"),
                      Positioned(
                        top: 100,
                        left: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            headerText(
                                "Hey, ${teamHomeCubit.state.userData!.firstName}!",
                                size: 25.0),
                            const Text(
                              "Check out your awesome \nteams!",
                              style: TextStyle(fontSize: 15),
                            )
                          ],
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                              padding: const EdgeInsets.only(bottom: 30.0),
                              child: SizedBox(
                                height: 100,
                                child: SvgPicture.asset(
                                    'assets/images/skateboard_homepage.svg'),
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: AppBar(
                          backgroundColor: yellowColor,
                          leading: profilePicture(
                              50, teamHomeCubit.state.userData!.avatarURL,
                              isUrl: true),
                          actions: [
                            IconButton(
                                onPressed: () => teamHomeCubit.handleSignOut(),
                                icon: const Icon(
                                  Icons.logout_outlined,
                                  color: blackColor,
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          const SizedBox(width: 25),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: teamHomeCubit.state.isLeading
                                    ? blackColor
                                    : whiteColor,
                                side: const BorderSide(
                                    width: 1, color: blackColor)),
                            onPressed: () {
                              teamHomeCubit.setIsLeadingState(true);
                            },
                            child: Text(
                              "Leading",
                              style: TextStyle(
                                color: teamHomeCubit.state.isLeading
                                    ? whiteColor
                                    : blackColor,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: teamHomeCubit.state.isLeading
                                    ? whiteColor
                                    : blackColor,
                                side: const BorderSide(
                                    width: 1, color: blackColor)),
                            onPressed: () {
                              teamHomeCubit.setIsLeadingState(false);
                            },
                            child: Text(
                              "Participating",
                              style: TextStyle(
                                  color: teamHomeCubit.state.isLeading
                                      ? blackColor
                                      : whiteColor,
                                  fontSize: 10),
                            ),
                          ),
                        ]),
                        Row(children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: yellowColor),
                            onPressed: () {
                              navigatePushWithData(context, "/create_teams",
                                      teamHomeCubit.state.userData!.id)
                                  .then((_) {
                                teamHomeCubit.initData();
                              });
                            },
                            child: const Text(
                              "Create Team",
                              style: TextStyle(color: blackColor, fontSize: 10),
                            ),
                          ),
                          const SizedBox(width: 25),
                        ]),
                      ]),

                  //Team Cards
                  if (teamHomeCubit.state.isLeading) ...[
                    teamHomeCubit.state.ownerTeamData.isEmpty
                        ? Column(children: [
                            const SizedBox(height: 150),
                            headerText("Uh oh. \nNo Leading Teams Found!",
                                alignment: TextAlign.center)
                          ])
                        : Column(children: [
                            for (int i = 0;
                                i < teamHomeCubit.state.ownerTeamData.length;
                                i++) ...[
                              const SizedBox(height: 20),
                              GestureDetector(
                                  onTap: () {
                                    navigatePushWithData(context, "/teams", [
                                      teamHomeCubit.state.ownerTeamData[i].id,
                                      true
                                    ]);
                                  },
                                  child: TeamHomeCard(
                                      teamData:
                                          teamHomeCubit.state.ownerTeamData[i]))
                            ],
                          ])
                  ] else ...[
                    teamHomeCubit.state.memberTeamData.isEmpty
                        ? Column(children: [
                            const SizedBox(height: 150),
                            headerText("Uh oh. \nNo Participating Teams Found!",
                                alignment: TextAlign.center),
                            ElevatedButton(
                                onPressed: () {
                                  navigatePush(context, "/discover");
                                },
                                child: smallText("  Search Teams  ")),
                          ])
                        : Column(children: [
                            for (int i = 0;
                                i < state.memberTeamData.length;
                                i++) ...[
                              const SizedBox(height: 20),
                              GestureDetector(
                                  onTap: () {
                                    navigatePushWithData(context, "/teams",
                                        [state.memberTeamData[i].id, false]);
                                  },
                                  child: TeamHomeCard(
                                      teamData: state.memberTeamData[i]))
                            ],
                          ])
                  ],

                  const SizedBox(height: 50),
                ]),
              ),
            )
          : const Center(child: CircularProgressIndicator());
    });
  }
}
