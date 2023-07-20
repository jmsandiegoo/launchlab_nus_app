import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/data/search/search_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/search/external_team_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/search/cubits/external_team_cubit.dart';
import 'package:launchlab/src/utils/helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExternalTeamPage extends StatelessWidget {
  final List teamIdUserIdData;
  const ExternalTeamPage({super.key, required this.teamIdUserIdData});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExternalTeamCubit(
          SearchRepository(), UserRepository(Supabase.instance)),
      child: ExternalTeamContent(teamIdUserIdData: teamIdUserIdData),
    );
  }
}

class ExternalTeamContent extends StatefulWidget {
  final List teamIdUserIdData;
  const ExternalTeamContent({super.key, required this.teamIdUserIdData});

  @override
  State<ExternalTeamContent> createState() => _ExternalTeamContentState();
}

class _ExternalTeamContentState extends State<ExternalTeamContent> {
  late ExternalTeamCubit externalTeamPageCubit;
  late ExternalTeamEntity teamData;

  @override
  void initState() {
    super.initState();
    externalTeamPageCubit = BlocProvider.of<ExternalTeamCubit>(context);
    externalTeamPageCubit.getData(widget.teamIdUserIdData[0]);
  }

  @override
  Widget build(BuildContext context) {
    final String teamId = widget.teamIdUserIdData[0];
    final String userId = widget.teamIdUserIdData[1];

    return BlocBuilder<ExternalTeamCubit, ExternalTeamState>(
        builder: (context, state) {
      if (externalTeamPageCubit.state.status == ExternalTeamStatus.success) {
        teamData = externalTeamPageCubit.state.teamData!;
      }

      return externalTeamPageCubit.state.status == ExternalTeamStatus.success
          ? Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: blackColor),
                  onPressed: () => navigatePop(context),
                ),
              ),
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              teamPicture(70, teamData.avatarURL, isUrl: true),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      subHeaderText(teamData.teamName),
                                      const SizedBox(height: 2),
                                      teamData.endDate == null
                                          ? boldFirstText("Deadline: ", 'None')
                                          : boldFirstText(
                                              "Deadline: ",
                                              dateToDateFormatter(
                                                  teamData.endDate)),
                                      boldFirstText(
                                          "Category: ", teamData.category),
                                      boldFirstText(
                                          "Commitment: ", teamData.commitment),
                                      boldFirstText("Interest Areas: ", ""),
                                      for (int i = 0;
                                          i < teamData.interest.length;
                                          i++) ...[
                                        smallText(teamData.interest[i]['name'])
                                      ]
                                    ]),
                              ),
                            ]),
                        const SizedBox(height: 20),
                        subHeaderText("Description"),
                        const SizedBox(height: 5),
                        bodyText(teamData.description),
                        const SizedBox(height: 20),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              boldFirstText("Members: ",
                                  "${teamData.currentMembers} / ${teamData.maxMembers}",
                                  size: 15.0),
                              const SizedBox(width: 20),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    subHeaderText("Owner: ", size: 15.0),
                                    const SizedBox(width: 5),
                                    externalTeamPageCubit.state.ownerData!.user
                                                .userAvatar ==
                                            null
                                        ? const SizedBox()
                                        : profilePicture(
                                            30.0,
                                            externalTeamPageCubit
                                                .state.ownerData!
                                                .getAvatarURL()!,
                                            isUrl: true),
                                    const SizedBox(width: 5),
                                    bodyText(
                                        externalTeamPageCubit.state.ownerData!
                                            .getFullName(),
                                        size: 13.0)
                                  ]),
                            ]),
                        const SizedBox(height: 40),
                        teamData.rolesOpen.isEmpty
                            ? const SizedBox()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    subHeaderText("Roles Needed"),
                                    const SizedBox(height: 10),
                                    for (int i = 0;
                                        i < teamData.rolesOpen.length;
                                        i++) ...[
                                      const SizedBox(height: 10),
                                      subHeaderText(
                                          teamData.rolesOpen[i]['title'],
                                          size: 15.0),
                                      bodyText(
                                          teamData.rolesOpen[i]['description']),
                                    ]
                                  ]),
                        const SizedBox(height: 50),
                        Center(
                          child: ElevatedButton(
                              child: bodyText("    Apply    "),
                              onPressed: () {
                                if (externalTeamPageCubit.state.currentMembers
                                    .contains(userId)) {
                                  confirmationBox(context, "Failure",
                                      "You cannot apply to the team that you are already in!");
                                } else if (externalTeamPageCubit
                                    .state.currentApplicants
                                    .contains(userId)) {
                                  confirmationBox(context, "Failure",
                                      "You have already applied to this team. \n\nPlease wait for the team owner to review your application.");
                                } else if (externalTeamPageCubit
                                    .state.pastApplicants
                                    .contains(userId)) {
                                  confirmationBox(context, "Success",
                                      "You have successfully applied to the team!");
                                  externalTeamPageCubit.reapplyToTeam(
                                      teamId: teamId, userId: userId);
                                  navigatePop(context);
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
            )
          : const Center(child: CircularProgressIndicator());
    });
  }
}
