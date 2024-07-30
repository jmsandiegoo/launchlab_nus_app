import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/team/cubits/team_home_cubit.dart';
import 'package:launchlab/src/presentation/team/widgets/team_home_item.dart';

class TeamHomeLeadingList extends StatelessWidget {
  const TeamHomeLeadingList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamHomeCubit, TeamHomeState>(
      builder: (context, state) {
        if (state.ownerTeamData.isEmpty || true) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                subHeaderText(
                    alignment: TextAlign.center,
                    "Uh oh... \n No Leading Teams Found."),
                primaryButton(context, () => {}, "Create Team"),
              ],
            ),
          );
        }

        return ListView(
          padding: EdgeInsets.zero,
          children: [
            ...state.ownerTeamData
                .map((teamData) => TeamHomeItem(teamData: teamData))
          ],
        );
      },
    );
  }
}
