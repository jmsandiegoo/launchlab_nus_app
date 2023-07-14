import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/team/cubits/team_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:launchlab/src/utils/constants.dart';

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
        create: (_) =>
            TeamCubit(TeamRepository(), UserRepository(Supabase.instance)),
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
                      Navigator.of(context).pop(ActionTypes.update);
                    } else if (purpose == 'Unlist') {
                      teamCubit.listTeam(teamId: teamId, isListed: false);
                      Navigator.of(context).pop(ActionTypes.update);
                    } else if (purpose == 'Disband') {
                      teamCubit.disbandTeam(teamId: teamId).then((_) {
                        Navigator.of(context).pop(ActionTypes.delete);
                      });
                    } else if (purpose == 'Leave') {
                      teamCubit.leaveTeam(teamId: teamId).then((_) {
                        Navigator.of(context).pop(ActionTypes.delete);
                      });
                    }
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
