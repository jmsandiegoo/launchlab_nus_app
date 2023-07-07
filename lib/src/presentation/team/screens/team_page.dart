import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/domain/team/team_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/team/cubits/team_cubit.dart';
import 'package:launchlab/src/presentation/team/widgets/manage_member_form.dart';
import 'package:launchlab/src/presentation/team/widgets/add_task.dart';
import 'package:launchlab/src/presentation/team/widgets/milestone_card.dart';
import 'package:launchlab/src/presentation/team/widgets/team_confirmation.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';

class TeamPage extends StatelessWidget {
  final List teamIdIsOwner;
  const TeamPage(this.teamIdIsOwner, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TeamCubit(TeamRepository()),
      child: TeamContent(teamIdIsOwner: teamIdIsOwner),
    );
  }
}

class TeamContent extends StatefulWidget {
  final List teamIdIsOwner;
  const TeamContent({super.key, required this.teamIdIsOwner});

  @override
  State<TeamContent> createState() => _TeamState();
}

class _TeamState extends State<TeamContent> {
  late TeamCubit teamCubit;
  late TeamEntity teamData;
  ActionTypes actionType = ActionTypes.cancel;

  @override
  void initState() {
    super.initState();
    teamCubit = BlocProvider.of<TeamCubit>(context);
    teamCubit.getData(widget.teamIdIsOwner[0]);
  }

  @override
  Widget build(BuildContext context) {
    final String teamId = widget.teamIdIsOwner[0];
    final bool isOwner = widget.teamIdIsOwner[1];
    return BlocBuilder<TeamCubit, TeamState>(builder: (context, state) {
      final teamCubit = BlocProvider.of<TeamCubit>(context);
      if (teamCubit.state.isLoaded) {
        teamData = teamCubit.state.teamData!;
      }
      return RefreshIndicator(
          onRefresh: () async {
            refreshPage();
          },
          child: teamCubit.state.isLoaded
              ? Scaffold(
                  appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back, color: blackColor),
                        onPressed: () =>
                            navigatePopWithData(context, '', actionType),
                      ),
                      actions: [
                        IconButton(
                            onPressed: () {
                              debugPrint("Add");
                            },
                            icon: const Icon(Icons.person_add_alt_1)),
                        IconButton(
                            onPressed: () {
                              debugPrint("Chat");
                            },
                            icon: const Icon(Icons.chat_bubble_outline)),
                        isOwner
                            ? PopupMenuButton<String>(
                                onSelected: _handleClick,
                                itemBuilder: (BuildContext context) {
                                  return {
                                    'Edit',
                                    teamData.isListed ? 'Unlist' : 'List',
                                    'Manage',
                                    'Disband'
                                  }.map((String choice) {
                                    return PopupMenuItem<String>(
                                        value: choice, child: Text(choice));
                                  }).toList();
                                },
                              )
                            : const SizedBox()
                      ]),
                  body: ListView(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              teamPicture(70, teamData.avatarURL),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                                child: subHeaderText(
                                                    teamData.teamName)),
                                            const SizedBox(width: 10),
                                            teamData.isListed
                                                ? subHeaderText("Listed",
                                                    size: 12.5,
                                                    color: const Color.fromARGB(
                                                        255, 71, 186, 75))
                                                : subHeaderText("Unlisted",
                                                    size: 12.5,
                                                    color: greyColor)
                                          ]),
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
                                      boldFirstText("Interest Areas: ", ''),
                                      for (int i = 0;
                                          i < teamData.interest.length;
                                          i++) ...[
                                        smallText(teamData.interest[i]['name'])
                                      ]
                                    ]),
                              ),
                            ]),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 30),
                                  subHeaderText("Description"),
                                  const SizedBox(height: 10),
                                  bodyText(teamData.description, size: 13.0),
                                  const SizedBox(height: 40),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          subHeaderText("Progress"),
                                          circleProgressBar(
                                              teamCubit.state.completedMilestone
                                                  .length,
                                              teamCubit
                                                      .state
                                                      .incompleteMilestone
                                                      .length +
                                                  teamCubit
                                                      .state
                                                      .completedMilestone
                                                      .length),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _manageMember(
                                            isOwner,
                                            teamCubit.state.memberData,
                                            teamId,
                                            teamData.currentMembers,
                                          );
                                        },
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(children: [
                                                subHeaderText("Members"),
                                                const SizedBox(width: 5),
                                                bodyText(
                                                    "${teamData.currentMembers} / ${teamData.maxMembers}",
                                                    size: 13.0),
                                                const SizedBox(width: 10),
                                                const Icon(Icons
                                                    .people_outline_outlined),
                                              ]),
                                              for (int i = 0;
                                                  i <
                                                          teamCubit
                                                              .state
                                                              .memberData
                                                              .length &&
                                                      i < 4;
                                                  i++) ...[
                                                memberProfile(
                                                    teamCubit
                                                        .state.memberData[i]
                                                        .getAvatarURL(),
                                                    teamCubit
                                                        .state.memberData[i]
                                                        .getFullName(),
                                                    teamCubit.state
                                                        .memberData[i].positon)
                                              ],
                                              if (teamCubit.state.memberData
                                                      .length >=
                                                  4) ...[
                                                const Center(child: Text("..."))
                                              ]
                                            ]),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        subHeaderText("Milestones"),
                                        GestureDetector(
                                            onTap: () {
                                              _addEditTask(teamData);
                                            },
                                            child: subHeaderText("Add Task +",
                                                size: 13.0))
                                      ]),
                                  for (int i = 0;
                                      i <
                                          teamCubit
                                              .state.incompleteMilestone.length;
                                      i++) ...[
                                    MilestoneCard(
                                        milestoneData: teamCubit
                                            .state.incompleteMilestone[i],
                                        isOwner: isOwner,
                                        teamCubit: teamCubit,
                                        teamId: teamId)
                                  ],
                                  //Milestones
                                  for (int i = 0;
                                      i <
                                          teamCubit
                                              .state.completedMilestone.length;
                                      i++) ...[
                                    MilestoneCard(
                                        milestoneData: teamCubit
                                            .state.completedMilestone[i],
                                        isOwner: isOwner,
                                        teamCubit: teamCubit,
                                        teamId: teamId)
                                  ],
                                  const SizedBox(height: 30),
                                ]),
                          ]),
                    ),
                  ]),
                )
              : const Center(child: CircularProgressIndicator()));
    });
  }

  void refreshPage() {
    teamCubit.loading();
    teamCubit.getData(teamData.id);
  }

  void _manageMember(isOwner, memberData, teamId, currentMembers) {
    showDialog(
        context: context,
        builder: (context) {
          return ManageMemberBox(
            isOwner: isOwner,
            memberData: memberData,
            onClose: () => Navigator.pop(context),
          );
        }).then((value) async {
      if (value != null && value[0] == 'Delete') {
        teamCubit
            .deleteMember(
                memberId: value[1],
                teamId: teamId,
                newCurrentMember: currentMembers - 1)
            .then((_) {
          refreshPage();
        });
      }
    });
  }

  void _addEditTask(TeamEntity teamData,
      {id = '',
      taskTitle = '',
      startDate = '',
      endDate = '',
      actionType = ActionTypes.create}) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        context: context,
        builder: (context) {
          return AddTaskBox(
              taskTitle: taskTitle,
              startDate: startDate,
              endDate: endDate,
              actionType: actionType);
        }).then((output) {
      if (output != null) {
        if (actionType == ActionTypes.create) {
          teamCubit.addMilestone(
              title: output[0],
              startDate: output[1],
              endDate: output[2],
              teamId: teamData.id);
        } else if (actionType == ActionTypes.update) {
          teamCubit.editMilestone(
              taskId: id,
              title: output[0],
              startDate: output[1],
              endDate: output[2]);
        }
        teamCubit.getData(teamData.id);
      }
    });
  }

  void _teamConfirmationBox({title, message, purpose}) {
    showDialog(
        context: context,
        builder: (context) {
          return TeamConfirmationBox(
            teamId: widget.teamIdIsOwner[0].toString(),
            title: title,
            message: message,
            purpose: purpose,
            onClose: () =>
                Navigator.of(context, rootNavigator: false).pop(false),
          );
        }).then((value) {
      if (value == ActionTypes.update) {
        refreshPage();
      }
      if (value == ActionTypes.delete) {
        navigatePopWithData(context, "", ActionTypes.update);
      }
    });
  }

  void _handleClick(String value) {
    switch (value) {
      case 'List':
        _teamConfirmationBox(
            title: 'Are you sure?',
            message: 'Do you really want to list this team?',
            purpose: 'List');
        break;
      case 'Unlist':
        _teamConfirmationBox(
            title: 'Are you sure?',
            message: 'Do you really want to unlist this team?',
            purpose: 'Unlist');
        break;
      case 'Manage':
        navigatePushWithData(context, "/team-home/teams/manage_teams",
                widget.teamIdIsOwner[0].toString())
            .then((value) {
          if (value?.actionType == ActionTypes.update) {
            refreshPage();
            actionType = ActionTypes.update;
          }
        });

        break;
      case 'Edit':
        navigatePushWithData(context, "/team-home/teams/edit_teams",
                widget.teamIdIsOwner[0].toString())
            .then((value) {
          if (value?.actionType == ActionTypes.update) {
            actionType = ActionTypes.update;
            refreshPage();
          }
        });
        break;
      case 'Disband':
        _teamConfirmationBox(
            title: 'Are you sure?',
            message: 'Do you really want to disband this team?',
            purpose: 'Disband');
        break;
    }
  }
}
