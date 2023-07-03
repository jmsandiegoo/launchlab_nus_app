import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/team/cubits/edit_create_team_cubit.dart';

class CommitmentButton extends StatelessWidget {
  final String text;
  final EditCreateTeamCubit cubit;
  final String newLevel;
  const CommitmentButton(
      {super.key,
      required this.text,
      required this.cubit,
      required this.newLevel});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            backgroundColor: cubit.state.commitmentInput == newLevel
                ? blackColor
                : lightGreyColor),
        onPressed: () {
          cubit.onCommitmentChanged(newLevel);
        },
        child: bodyText(text,
            size: 12.0,
            color: cubit.state.commitmentInput == newLevel
                ? whiteColor
                : blackColor));
  }
}
