import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/team/cubits/team_cubit.dart';
import 'package:launchlab/src/presentation/team/widgets/manage_member_form.dart';
import 'package:launchlab/src/presentation/team/widgets/add_task.dart';
import 'package:launchlab/src/presentation/team/widgets/team_confirmation.dart';
import 'package:launchlab/src/utils/helper.dart';

class TeamPage extends StatefulWidget {
  final List teamIdIsOwner;
  const TeamPage(this.teamIdIsOwner, {super.key});

  @override
  // ignore: no_logic_in_create_state
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  _TeamPageState();

  @override
  Widget build(BuildContext context) {
    final String teamId = widget.teamIdIsOwner[0];
    final bool isOwner = widget.teamIdIsOwner[1];
    return BlocProvider(
        create: (_) => TeamCubit(),
        child: BlocBuilder<TeamCubit, TeamState>(builder: (context, state) {
          final teamCubit = BlocProvider.of<TeamCubit>(context);

          return FutureBuilder(
              future: teamCubit.getData(teamId),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  final List memberData = snapshot.data[0];
                  final List completedMilestone = snapshot.data[1];
                  final List incompleteMilestone = snapshot.data[2];
                  final Map teamData = snapshot.data[3][0];

                  return Scaffold(
                    appBar: AppBar(
                        backgroundColor: Colors.transparent,
                        iconTheme: const IconThemeData(color: blackColor),
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
                                      teamData['is_listed'] ? 'Unlist' : 'List',
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
                    body: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                teamPicture(70, teamData['avatar_url']),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        subHeaderText(teamData['team_name']),
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
                                        boldFirstText("Interest Areas: ", ''),
                                        for (int i = 0;
                                            i < teamData['interest'].length;
                                            i++) ...[
                                          smallText(
                                              teamData['interest'][i]['name'])
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
                                    bodyText(teamData['description'],
                                        size: 13.0),
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
                                                completedMilestone.length,
                                                incompleteMilestone.length +
                                                    completedMilestone.length),
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _manageMember(
                                              isOwner,
                                              memberData,
                                              teamId,
                                              teamData['current_members'],
                                              teamCubit,
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
                                                      "${teamData['current_members']} / ${teamData['max_members']}",
                                                      size: 13.0),
                                                  const SizedBox(width: 10),
                                                  const Icon(Icons
                                                      .people_outline_outlined),
                                                ]),
                                                for (int i = 0;
                                                    i < memberData.length &&
                                                        i < 4;
                                                    i++) ...[
                                                  memberProfile(
                                                      memberData[i]['users']
                                                          ['avatar_url'],
                                                      "${memberData[i]['users']['first_name']} ${memberData[i]['users']['last_name']}",
                                                      memberData[i]['position'])
                                                ],
                                                if (memberData.length >= 4) ...[
                                                  const Center(
                                                      child: Text("..."))
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
                                                _addTask(teamData, teamCubit);
                                              },
                                              child: subHeaderText("Add Task +",
                                                  size: 13.0))
                                        ]),
                                    for (int i = 0;
                                        i < incompleteMilestone.length;
                                        i++) ...[
                                      _taskCard(
                                          incompleteMilestone[i]['title'],
                                          incompleteMilestone[i]
                                              ['is_completed'],
                                          incompleteMilestone[i]['id'],
                                          isOwner,
                                          teamCubit),
                                    ],
                                    //Milestones
                                    for (int i = 0;
                                        i < completedMilestone.length;
                                        i++) ...[
                                      _taskCard(
                                          completedMilestone[i]['title'],
                                          completedMilestone[i]['is_completed'],
                                          completedMilestone[i]['id'],
                                          isOwner,
                                          teamCubit),
                                    ],
                                  ]),
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

  void _manageMember(isOwner, memberData, teamId, currentMembers, cubit) {
    showDialog(
        context: context,
        builder: (context) {
          return ManageMemberBox(
            isOwner: isOwner,
            memberData: memberData,
            onClose: () => Navigator.pop(context),
          );
        }).then((value) {
      if (value != null && value[0] == 'Delete') {
        cubit
            .deleteMember(
                memberId: value[1],
                teamId: teamId,
                newCurrentMember: currentMembers - 1)
            .then((_) {
          setState(() {});
        });
      }
    });
  } //manageMember

  void _addTask(teamData, teamCubit) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        context: context,
        builder: (context) {
          return const AddTaskBox();
        }).then((output) {
      //Add new Task here -- to database
      if (output != null) {
        teamCubit.addMilestone(
            title: output[0],
            startDate: output[1],
            endDate: output[2],
            teamData: teamData);
        setState(() {});
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
            onClose: () => Navigator.of(context, rootNavigator: false).pop(),
          );
        }).then((_) {
      setState(() {});
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
        navigatePushWithData(
            context, "/manage_teams", widget.teamIdIsOwner[0].toString());
        break;
      case 'Edit':
        navigatePushWithData(
            context, "/edit_teams", widget.teamIdIsOwner[0].toString());
        break;
      case 'Disband':
        _teamConfirmationBox(
            title: 'Are you sure?',
            message: 'Do you really want to disband this team?',
            purpose: 'Disband');

        break;
    }
  }

  Widget _taskCard(taskName, isChecked, taskId, isOwner, cubit) {
    void manageTask(String value) {
      switch (value) {
        case 'Delete':
          cubit.deleteTask(taskId: taskId);
          setState(() {});
          break;
      }
    }

    return Column(children: [
      const SizedBox(height: 20),
      Container(
        decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 3,
                offset: const Offset(0, 3),
              )
            ]),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Checkbox(
              value: isChecked,
              onChanged: (bool? value) {
                cubit.saveMilestoneCheckData(val: value, taskId: taskId);
                setState(() {});
              },
              activeColor: yellowColor,
            ),
            SizedBox(
              width: 230,
              child: Text(
                taskName,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                  decoration: isChecked
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
          ]),
          isOwner
              ? Flexible(
                  flex: 1,
                  child: PopupMenuButton<String>(
                    onSelected: manageTask,
                    itemBuilder: (BuildContext context) {
                      return {'Delete'}.map((String choice) {
                        return PopupMenuItem<String>(
                            value: choice, child: Text(choice));
                      }).toList();
                    },
                  ))
              : const SizedBox(),
        ]),
      )
    ]);
  } //addTask
}
