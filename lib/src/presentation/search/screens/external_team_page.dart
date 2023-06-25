import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/search/cubits/external_team_cubit.dart';
import 'package:launchlab/src/utils/helper.dart';

class ExternalTeamPage extends StatefulWidget {
  final List teamIdUserIdData;
  const ExternalTeamPage({super.key, required this.teamIdUserIdData});

  @override
  State<ExternalTeamPage> createState() => _ExternalTeamPageState();
}

class _ExternalTeamPageState extends State<ExternalTeamPage> {
  @override
  Widget build(BuildContext context) {
    final String teamId = widget.teamIdUserIdData[0];
    final String userId = widget.teamIdUserIdData[1];

    return BlocProvider(
        create: (_) => ExternalTeamCubit(),
        child: BlocBuilder<ExternalTeamCubit, ExternalTeamState>(
            builder: (context, state) {
          final externalTeamPageCubit =
              BlocProvider.of<ExternalTeamCubit>(context);
          return FutureBuilder(
              future: externalTeamPageCubit.getData(teamId),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData) {
                  final Map teamData = snapshot.data[0][0];
                  final String ownerName =
                      "${snapshot.data[1][0]['first_name']} ${snapshot.data[1][0]['last_name']}";
                  final List currentApplicants = [];
                  final List currentMembers = [];
                  teamData['team_users'].forEach((user) {
                    currentMembers.add(user['user_id']);
                  });
                  snapshot.data[2].forEach((user) {
                    currentApplicants.add(user['user_id']);
                  });

                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      iconTheme: const IconThemeData(color: blackColor),
                    ),
                    body: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    teamPicture(70, teamData['avatar_url']),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            subHeaderText(
                                                teamData['team_name']),
                                            //subHeaderText("     Listed 5h ago", size: 11.0, color: Colors.green)

                                            const SizedBox(height: 2),
                                            teamData['end_date'] == null
                                                ? boldFirstText(
                                                    "Deadline: ", 'None')
                                                : boldFirstText(
                                                    "Deadline: ",
                                                    stringToDateFormatter(
                                                        teamData['end_date'])),
                                            boldFirstText("Category: ",
                                                teamData['project_category']),
                                            boldFirstText("Commitment: ",
                                                teamData['commitment']),
                                            boldFirstText(
                                                "Interest Areas: ", ""),
                                            for (int i = 0;
                                                i < teamData['interest'].length;
                                                i++) ...[
                                              smallText(teamData['interest'][i]
                                                  ['name'])
                                            ]
                                          ]),
                                    ),
                                  ]),
                              const SizedBox(height: 20),
                              subHeaderText("Description"),
                              const SizedBox(height: 5),
                              bodyText(teamData['description']),
                              const SizedBox(height: 20),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    boldFirstText("Members: ",
                                        "${teamData['current_members']} / ${teamData['max_members']}",
                                        size: 15.0),
                                    const SizedBox(width: 20),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          subHeaderText("Owner: ", size: 15.0),
                                          const SizedBox(width: 5),
                                          profilePicture(30.0,
                                              snapshot.data[1][0]['avatar_url'],
                                              isUrl: true),
                                          const SizedBox(width: 5),
                                          bodyText(ownerName, size: 13.0)
                                        ]),
                                  ]),
                              const SizedBox(height: 40),
                              teamData['roles_open'].length == 0
                                  ? const SizedBox()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                          subHeaderText("Roles Needed"),
                                          const SizedBox(height: 10),
                                          for (int i = 0;
                                              i < teamData['roles_open'].length;
                                              i++) ...[
                                            const SizedBox(height: 10),
                                            subHeaderText(
                                                teamData['roles_open'][i]
                                                    ['title'],
                                                size: 15.0),
                                            bodyText(teamData['roles_open'][i]
                                                ['description']),
                                          ]
                                        ]),
                              const SizedBox(height: 50),
                              Center(
                                child: ElevatedButton(
                                    child: bodyText("   Apply   "),
                                    onPressed: () {
                                      if (currentMembers.contains(userId)) {
                                        confirmationBox(context, "Failure",
                                            "You cannot apply to the team that you are already in!");
                                      } else if (currentApplicants
                                          .contains(userId)) {
                                        confirmationBox(context, "Failure",
                                            "You have already applied to this team. \n\nPlease wait for the team owner to review your application.");
                                      } else {
                                        confirmationBox(context, "Success",
                                            "You have successfully applied to the team!");
                                        externalTeamPageCubit.applyToTeam(
                                            teamId: teamId, userId: userId);
                                        navigatePop(context);
                                      }
                                    }),
                              ),
                            ]),
                      ),
                    ),
                  );
                } else {
                  return futureBuilderFail(() => setState(() {}));
                }
              });
        }));
  }
}
