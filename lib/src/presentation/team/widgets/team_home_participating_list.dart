import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/team/cubits/team_home_cubit.dart';
import 'package:launchlab/src/presentation/team/widgets/team_home_item.dart';

class TeamHomeParticipatingList extends StatelessWidget {
  const TeamHomeParticipatingList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamHomeCubit, TeamHomeState>(
      builder: (context, state) {
        if (state.memberTeamData.isEmpty) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                subHeaderText(
                    alignment: TextAlign.center,
                    "Uh oh... \n No Participating Teams Found."),
                const SizedBox(height: 15,),
                primaryButton(context, () => {}, "Find Team"),
              ],
            ),
          );
        }

        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            ...state.memberTeamData
                .map((teamData) => TeamHomeItem(teamData: teamData, onPressedHandler: () {},))
          ],
        );
      },
    );
  }
}
