import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:launchlab/src/data/authentication/repository/auth_repository.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/team/cubits/team_home_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeamHomePage extends StatelessWidget {
  const TeamHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TeamHomeCubit(AuthRepository(Supabase.instance)),
      child: BlocBuilder<TeamHomeCubit, TeamHomeState>(
        builder: (context, state) {
          final teamHomeCubit = BlocProvider.of<TeamHomeCubit>(context);
          return Scaffold(
            backgroundColor: lightGreyColor,
            appBar: AppBar(
              leading:
                  profilePicture(45, "assets/images/circle_profile_pic.png"),
              actions: [
                IconButton(
                    onPressed: () => teamHomeCubit.handleSignOut(),
                    icon: const Icon(Icons.logout_outlined))
              ],
            ),
            body: SingleChildScrollView(
              child: Column(children: [
                Stack(
                  children: <Widget>[
                    Image.asset("assets/images/yellow_curve_shape_3.png"),
                    const Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: 60),
                        ]),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SvgPicture.asset(
                            'assets/images/skateboard_homepage.svg'),
                      ),
                    ),
                    Positioned(
                      top: 130,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          headerText("Hi John!", size: 30.0),
                          const Text(
                            "Check out your awesome \nteams!",
                            style: TextStyle(fontSize: 15),
                          )
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
                              backgroundColor:
                                  state.isLeading ? blackColor : whiteColor,
                              side: const BorderSide(
                                  width: 1, color: blackColor)),
                          onPressed: () {
                            teamHomeCubit.setIsLeadingState(true);
                          },
                          child: Text(
                            "Leading",
                            style: TextStyle(
                              color: state.isLeading ? whiteColor : blackColor,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  state.isLeading ? whiteColor : blackColor,
                              side: const BorderSide(
                                  width: 1, color: blackColor)),
                          onPressed: () {
                            teamHomeCubit.setIsLeadingState(false);
                          },
                          child: Text(
                            "Participating",
                            style: TextStyle(
                              color: state.isLeading ? blackColor : whiteColor,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ]),
                      Row(children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: yellowColor),
                          onPressed: () {
                            //To navigate to create team page.
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

                state.isLeading
                    ? Column(children: [
                        const SizedBox(height: 150),
                        headerText("Uh oh. \nNo Leading Teams Found!",
                            alignment: TextAlign.center)
                      ])
                    : GestureDetector(
                        onTap: () {
                          debugPrint("Go to Teams Page");
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 20),
                          child: Column(children: [
                            Container(
                              width: double.infinity,
                              color: whiteColor,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        profilePicture(
                                            35, "assets/images/test.jpeg"),
                                        const SizedBox(width: 10),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              subHeaderText("Project Rama"),
                                              const SizedBox(height: 5),
                                              bodyText("Progress 50%",
                                                  color: darkGreyColor,
                                                  size: 12.0),
                                            ])
                                      ]),
                                      const SizedBox(height: 15),
                                      bodyText(
                                          "Lorem ipsum dolor sit amet, consectetur adipiscing "
                                          "elit, sed do eiusmod tempor incididunt",
                                          color: darkGreyColor),
                                      const SizedBox(height: 15),
                                      Row(
                                        children: [
                                          const Icon(Icons.people_alt_outlined,
                                              size: 20),
                                          const SizedBox(width: 10),
                                          subHeaderText("2 / 2", size: 15.0),
                                        ],
                                      )
                                    ]),
                              ),
                            ),
                          ]),
                        ),
                      )
              ]),
            ),
          );
        },
      ),
    );
  }
}
