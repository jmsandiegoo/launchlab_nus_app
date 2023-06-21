import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/team/cubits/team_cubit.dart';
import 'package:launchlab/src/presentation/team/widgets/manage_member_form.dart';
import 'package:launchlab/src/presentation/team/widgets/add_task.dart';
import 'package:launchlab/src/utils/helper.dart';

class TeamPage extends StatefulWidget {
  final List teamIdIsOwner;
  const TeamPage(this.teamIdIsOwner, {super.key});

  @override
  // ignore: no_logic_in_create_state
  State<TeamPage> createState() => _TeamPageState(teamIdIsOwner);
}

class _TeamPageState extends State<TeamPage> {
  _TeamPageState(this.teamIdIsOwner);

  final List teamIdIsOwner;

  @override
  Widget build(BuildContext context) {
    final String teamId = teamIdIsOwner[0];
    final bool isOwner = teamIdIsOwner[1];
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
                                  onSelected: handleClick,
                                  itemBuilder: (BuildContext context) {
                                    return {
                                      teamData['is_listed'] ? 'Unlist' : 'List',
                                      'Edit',
                                      'Disband'
                                    }.map((String choice) {
                                      choice == 'List'
                                          ? debugPrint("list")
                                          : choice == 'Unlist'
                                              ? debugPrint('Unlist')
                                              : choice == 'Disband'
                                                  ? debugPrint('Disband')
                                                  : debugPrint(
                                                      "Nothing Happened");
                                      return PopupMenuItem<String>(
                                          value: choice, child: Text(choice));
                                    }).toList();
                                  },
                                )
                              : SizedBox()
                        ]),
                    body: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                profilePicture(70, "test.jpeg"),
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
                                            manageMember(memberData);
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
                                                      "circle_profile_pic.png",
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
                                                addTask(teamData, teamCubit);
                                              },
                                              child: subHeaderText("Add Task +",
                                                  size: 13.0))
                                        ]),
                                    for (int i = 0;
                                        i < incompleteMilestone.length;
                                        i++) ...[
                                      taskCard(
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
                                      taskCard(
                                          completedMilestone[i]['title'],
                                          completedMilestone[i]['is_completed'],
                                          completedMilestone[i]['id'],
                                          isOwner,
                                          teamCubit),
                                    ],
                                  ]),
                              const SizedBox(height: 0),
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

  void manageMember(memberData) {
    showDialog(
      context: context,
      builder: (context) {
        return ManageMemberBox(
          memberData: memberData,
          onClose: () => navigatePop(context),
        );
      },
    );
  } //manageMember

  void addTask(teamData, teamCubit) {
    showModalBottomSheet(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
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

  void handleClick(String value) {
    switch (value) {
      case 'Unlist':
        debugPrint("Unlist");
        break;
      case 'List':
        debugPrint("List");
        break;
      case 'Edit':
        navigatePushData(context, "/edit_teams", teamIdIsOwner[0].toString());
        break;
      case 'Disband':
        debugPrint("Disband");

        break;
    }
  }

  Widget taskCard(taskName, isChecked, taskId, isOwner, teamCubit) {
    void manageTask(String value) {
      switch (value) {
        case 'Delete':
          teamCubit.deleteTask(taskId: taskId);
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
                teamCubit.saveMilestoneCheckData(val: value, taskId: taskId);
                setState(() {});
              },
              activeColor: yellowColor,
            ),
            SizedBox(
              width: 250,
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
              ? PopupMenuButton<String>(
                  onSelected: manageTask,
                  itemBuilder: (BuildContext context) {
                    return {'Delete'}.map((String choice) {
                      return PopupMenuItem<String>(
                          value: choice, child: Text(choice));
                    }).toList();
                  },
                )
              : const SizedBox()
        ]),
      )
    ]);
  } //addTask
}
