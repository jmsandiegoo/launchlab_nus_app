import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/search/cubits/external_team_cubit.dart';
import 'package:launchlab/src/presentation/common/widgets/confirmation_box.dart';
import 'package:launchlab/src/utils/helper.dart';

class ExternalTeamPage extends StatelessWidget {
  final List teamIdUserIdData;
  const ExternalTeamPage({super.key, required this.teamIdUserIdData});

  @override
  Widget build(BuildContext context) {
    final String teamId = teamIdUserIdData[0];
    final String userId = teamIdUserIdData[1];

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
                          horizontal: 40, vertical: 10),
                      child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    profilePicture(70, "test.jpeg"),
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
                                            boldFirstText(
                                                "Deadline: ", "31 May 2023"),
                                            boldFirstText("Category: ",
                                                teamData['project_category']),
                                            boldFirstText("Commitment: ",
                                                teamData['commitment']),
                                            boldFirstText(
                                                "Interest & Skills Involved: ",
                                                ""),
                                            boldFirstText(
                                                "Interest ", "Placeholder")
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
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          subHeaderText("Owner: ", size: 15.0),
                                          const SizedBox(width: 5),
                                          profilePicture(
                                              30.0, "circle_profile_pic.png"),
                                          const SizedBox(width: 5),
                                          bodyText(ownerName, size: 13.0)
                                        ]),
                                  ]),
                              const SizedBox(height: 40),
                              subHeaderText("Roles Needed"),
                              const SizedBox(height: 10),
                              const SizedBox(height: 10),
                              subHeaderText("Frontend Developer", size: 15.0),
                              bodyText(
                                  "Lorem ipsum dolor sit amet, consectetur adipiscing"),
                              const SizedBox(height: 10),
                              subHeaderText("App Developer", size: 15.0),
                              bodyText(
                                  "Lorem ipsum dolor sit amet, consectetur adipiscing"),
                              const SizedBox(height: 10),
                              subHeaderText("Analyst", size: 15.0),
                              bodyText(
                                  "Lorem ipsum dolor sit amet, consectetur adipiscing"),
                              const SizedBox(height: 40),
                              Center(
                                child: ElevatedButton(
                                    child: bodyText("   Apply   "),
                                    onPressed: () {
                                      if (currentMembers.contains(userId)) {
                                        applicationConfirmationBox(
                                            context,
                                            "Failure",
                                            "You cannot apply to the team that you are already in!");
                                      } else if (currentApplicants
                                          .contains(userId)) {
                                        applicationConfirmationBox(
                                            context,
                                            "Failure",
                                            "You have already applied to this team. \n\nPlease wait for the team owner to review your application.");
                                      } else {
                                        externalTeamPageCubit.applyToTeam(
                                            teamId: teamId, userId: userId);
                                        navigatePop(context);
                                        applicationConfirmationBox(
                                            context,
                                            "Success",
                                            "You have successfully applied to the team!");
                                      }
                                    }),
                              ),
                            ]),
                      ),
                    ),
                  );
                } else {
                  return futureBuilderFail();
                }
              });
        }));
  }

  void applicationConfirmationBox(context, title, message) {
    showDialog(
      context: context,
      builder: (context) {
        return ConfirmationBox(
          title: title,
          message: message,
          onClose: () => navigatePop(context),
        );
      },
    );
  }
}
