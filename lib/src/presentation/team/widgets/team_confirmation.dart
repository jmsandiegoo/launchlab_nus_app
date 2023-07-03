import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/team/cubits/team_cubit.dart';
import 'package:launchlab/src/utils/helper.dart';

class TeamConfirmationBox extends StatelessWidget {
  final VoidCallback onClose;
  final String teamId;
  final String title;
  final String purpose;
  final String message;

  const TeamConfirmationBox({
    super.key,
    required this.title,
    required this.message,
    required this.purpose,
    required this.onClose,
    required this.teamId,
  });

//Purpose are Disband, List, Unlist

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => TeamCubit(TeamRepository()),
        child: BlocBuilder<TeamCubit, TeamState>(builder: (context, state) {
          final teamCubit = BlocProvider.of<TeamCubit>(context);
          return AlertDialog(
            title: Text(title),
            content: bodyText(message),
            actions: [
              TextButton(
                  onPressed: () async {
                    if (purpose == 'List') {
                      teamCubit.listTeam(teamId: teamId, isListed: true);
                    } else if (purpose == 'Unlist') {
                      teamCubit.listTeam(teamId: teamId, isListed: false);
                    } else if (purpose == 'Disband') {
                      teamCubit.disbandTeam(teamId: teamId);
                      navigateGo(context, '/team-home');
                    }
                    Navigator.of(context).pop(true);
                  },
                  style: TextButton.styleFrom(textStyle: const TextStyle()),
                  child: bodyText('Yes',
                      weight: FontWeight.bold, color: Colors.blue)),
              TextButton(
                  onPressed: onClose,
                  style: TextButton.styleFrom(textStyle: const TextStyle()),
                  child: bodyText('No',
                      weight: FontWeight.bold, color: Colors.blue)),
            ],
          );
        }));
  }
}
