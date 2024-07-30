import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/cubits/app_root_cubit.dart';
import 'package:launchlab/src/presentation/common/widgets/text/ll_body_text.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/team/cubits/team_home_cubit.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';

class TeamHomeHeader extends StatelessWidget {
  const TeamHomeHeader({super.key});

  @override
  build(BuildContext context) {
    AppRootCubit appRootCubit = BlocProvider.of<AppRootCubit>(context);
    TeamHomeCubit teamHomeCubit = BlocProvider.of<TeamHomeCubit>(context);
    return Container(
      color: yellowColor,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  profilePicture(
                      40, teamHomeCubit.state.userData?.userAvatar?.signedUrl ?? "",
                      isUrl: true),
                  IconButton(
                      onPressed: () => appRootCubit.handleSignOut(),
                      icon: const Icon(
                        Icons.logout_outlined,
                        color: blackColor,
                      ))
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      headerText("Hey, ${teamHomeCubit.state.userData?.firstName}"),
                      const LLBodyText(label: "Check out your awesome \nteams!"),
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Image.asset(
                  scale: 1.65,
                  'assets/images/team_home_skateboard.png',
                  fit: BoxFit.contain,
                ),
              )
            ]),
            const SizedBox(height: 10.0),
            Container(
              color: lightGreyColor,
              child: Image.asset('assets/images/yellow_wave_divider.png',
                  fit: BoxFit.fill),
            ),
            Container(height: 10.0, color: lightGreyColor),
            Container(
              color: lightGreyColor,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      const SizedBox(width: 25),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            backgroundColor: teamHomeCubit.state.isLeading
                                ? blackColor
                                : whiteColor,
                            side:
                                const BorderSide(width: 1, color: blackColor)),
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
                            side:
                                const BorderSide(width: 0.5, color: blackColor)),
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
                          navigatePushWithData(
                                  context,
                                  "/team-home/create_teams",
                                  teamHomeCubit.state.userData!.id)
                              .then((value) {
                            if (value?.actionType == ActionTypes.create) {
                              teamHomeCubit.setIsLeadingState(false);
                              teamHomeCubit.getData();
                            }
                          });
                        },
                        child: const Text(
                          "Create",
                          style: TextStyle(color: blackColor, fontSize: 10),
                        ),
                      ),
                      const SizedBox(width: 15.0),
                    ]),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
