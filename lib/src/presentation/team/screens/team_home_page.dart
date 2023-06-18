import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:launchlab/src/data/authentication/repository/auth_repository.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/team/cubits/team_home_cubit.dart';
import 'package:launchlab/src/utils/helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeamHomePage extends StatefulWidget {
  const TeamHomePage({super.key});

  @override
  State<TeamHomePage> createState() => _TeamHomePageState();
}

class _TeamHomePageState extends State<TeamHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TeamHomeCubit(AuthRepository(Supabase.instance)),
      child: BlocBuilder<TeamHomeCubit, TeamHomeState>(
        builder: (context, state) {
          final teamHomeCubit = BlocProvider.of<TeamHomeCubit>(context);

          return FutureBuilder(
            future: teamHomeCubit.getData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                List memberTeamData = snapshot.data[0];
                List ownerTeamData = snapshot.data[1];
                List userData = snapshot.data[2];
                return Scaffold(
                  backgroundColor: lightGreyColor,
                  body: SingleChildScrollView(
                    child: Column(children: [
                      Stack(
                        children: <Widget>[
                          Image.asset("assets/images/yellow_curve_shape.png"),
                          Positioned(
                            top: 150,
                            left: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                headerText("Hey, ${userData[0]['first_name']}!",
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: AppBar(
                              leading:
                                  profilePicture(50, "circle_profile_pic.png"),
                              actions: [
                                IconButton(
                                    onPressed: () =>
                                        teamHomeCubit.handleSignOut(),
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
                                    backgroundColor: state.isLeading
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
                                    color: state.isLeading
                                        ? whiteColor
                                        : blackColor,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    backgroundColor: state.isLeading
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
                                      color: state.isLeading
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
                                  navigatePushData(context, "/create_teams",
                                          userData[0]['id'] as String)
                                      .then((_) => setState(() {
                                            teamHomeCubit
                                                .setIsLeadingState(false);
                                            teamHomeCubit
                                                .setIsLeadingState(true);
                                          }));
                                },
                                child: const Text(
                                  "Create Team",
                                  style: TextStyle(
                                    color: blackColor,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 25),
                            ]),
                          ]),

                      //Team Cards
                      if (state.isLeading) ...[
                        ownerTeamData.isEmpty
                            ? Column(children: [
                                const SizedBox(height: 150),
                                headerText("Uh oh. \nNo Leading Teams Found!",
                                    alignment: TextAlign.center)
                              ])
                            : Column(children: [
                                for (int i = 0;
                                    i < ownerTeamData.length;
                                    i++) ...[
                                  const SizedBox(height: 20),
                                  GestureDetector(
                                      onTap: () {
                                        navigatePushData(context, "/teams",
                                            [ownerTeamData[i]['id'], true]);
                                      },
                                      child: teamCard(ownerTeamData[i]))
                                ],
                              ])
                      ] else ...[
                        memberTeamData.isEmpty
                            ? Column(children: [
                                const SizedBox(height: 150),
                                headerText(
                                    "Uh oh. \nNo Participating Teams Found!",
                                    alignment: TextAlign.center),
                                ElevatedButton(
                                    onPressed: () {
                                      navigatePush(context, "/discover");
                                    },
                                    child: bodyText("Search Teams")),
                              ])
                            : Column(children: [
                                for (int i = 0;
                                    i < memberTeamData.length;
                                    i++) ...[
                                  const SizedBox(height: 20),
                                  GestureDetector(
                                      onTap: () {
                                        navigatePushData(context, "/teams",
                                            [memberTeamData[i]['id'], false]);
                                      },
                                      child: teamCard(memberTeamData[i]))
                                ],
                              ])
                      ],

                      const SizedBox(height: 50),
                    ]),
                  ),
                );
              } else {
                return futureBuilderFail();
              }
            },
          );
        },
      ),
    );
  }

  Widget teamCard(data) {
    String teamName = data['team_name'];
    String description = data['description'];
    int currentMember = data['current_members'];
    int maxMember = data['max_members'];
    String commitment = data['commitment'];
    String category = data['project_category'];
    String? endDate = data['end_date'];
    int incompleteTask =
        data['milestones'].where((map) => map['is_completed'] == false).length;
    int completedTask =
        data['milestones'].where((map) => map['is_completed'] == true).length;
    int totalTask = incompleteTask + completedTask;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(children: [
        Container(
          width: double.infinity,
          color: whiteColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                profilePicture(40, "test.jpeg"),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        subHeaderText(teamName),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(Icons.people_alt_outlined, size: 12),
                            const SizedBox(width: 5),
                            subHeaderText("$currentMember / $maxMember",
                                size: 12.0),
                          ],
                        )
                      ]),
                ),
              ]),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                boldFirstText("Category: ", category),
                endDate == null
                    ? boldFirstText("Deadline: ", 'None')
                    : boldFirstText(
                        "Deadline: ", stringToDateFormatter(endDate)),
                const SizedBox(width: 5),
              ]),
              const SizedBox(height: 5),
              boldFirstText("Commitment Level: ", commitment),
              const SizedBox(height: 10),
              descriptionText(description, color: darkGreyColor),
              const SizedBox(height: 15),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                bodyText(
                    "Progress ${totalTask == 0 ? 0 : ((completedTask / totalTask) * 100).round()}%",
                    color: darkGreyColor,
                    size: 12.0),
              ]),
            ]),
          ),
        ),
      ]),
    );
  }
}
