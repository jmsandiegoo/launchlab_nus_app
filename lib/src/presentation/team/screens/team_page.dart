import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/data/authentication/repository/auth_repository.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/team/cubits/team_cubit.dart';
import 'package:launchlab/src/presentation/team/widgets/manage_member_form.dart';
import 'package:launchlab/src/presentation/team/widgets/add_task.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TeamCubit(AuthRepository(Supabase.instance)),
      child: BlocBuilder<TeamCubit, TeamState>(
        builder: (context, state) {
          final teamCubit = BlocProvider.of<TeamCubit>(context);
          return Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                iconTheme: const IconThemeData(color: blackColor),
                actions: [
                  IconButton(
                      onPressed: () => debugPrint("Add"),
                      icon: const Icon(Icons.person_add_alt_1)),
                  IconButton(
                      onPressed: () {
                        debugPrint("Chat");
                      },
                      icon: const Icon(Icons.chat_bubble_outline)),
                  PopupMenuButton<String>(
                    onSelected: handleClick,
                    itemBuilder: (BuildContext context) {
                      return {'Unlist', 'Edit', 'Disband'}.map((String choice) {
                        return PopupMenuItem<String>(
                            value: choice, child: Text(choice));
                      }).toList();
                    },
                  ),
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
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              subHeaderText("Project Rama"),
                              boldFirstText("Deadline: ", "31 May 2023"),
                              boldFirstText("Category: ", "Startup"),
                              boldFirstText("Commitment: ", "High"),
                            ]),
                      ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30),
                            subHeaderText("Description"),
                            const SizedBox(height: 10),
                            bodyText(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing "
                                "elit, sed do eiusmod tempor incididunt ut labore et "
                                "dolore magna aliqua. Ut enim ad minim veniam, quis "
                                "nostrud exercitation ullamco laboris nisi ut aliquip ex "
                                "ea commodo consequat. Duis aute irure dolor in "
                                "reprehenderit in voluptate velit esse cillum dolore eu "
                                "fugiat nulla pariatur. Excepteur sint occaecat cupidatat "
                                "non proident, sunt in culpa qui officia deserunt mollit "
                                "anim id est laborum.",
                                size: 13.0),
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    subHeaderText("Progress"),
                                    circleProgressBar(
                                        state.currentTask, state.totalTask),
                                  ],
                                ),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            manageMember();
                                          },
                                          child: Row(children: [
                                            subHeaderText("Members"),
                                            const SizedBox(width: 5),
                                            bodyText("2 / 2", size: 13.0),
                                            const SizedBox(width: 10),
                                            const Icon(Icons.person),
                                          ])),
                                      memberProfile("circle_profile_pic.png",
                                          "John Doe", "CEO"),
                                      memberProfile(
                                          "test_2.webp", "San Diego", "CTO"),
                                    ]),
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
                                        addTask();
                                      },
                                      child: subHeaderText("Add Task +",
                                          size: 13.0))
                                ]),

                            //Milestones
                            manageTask("Task1", state, teamCubit),
                          ]),
                      const SizedBox(height: 50),
                    ]),
              ),
            ),
          );
        },
      ),
    );
  }

  void manageMember() {
    showDialog(
      context: context,
      builder: (context) {
        return ManageMemberBox(
          onClose: () => Navigator.of(context).pop(),
        );
      },
    );
  } //manageMember

  final _controller = TextEditingController();
  void addTask() {
    showModalBottomSheet(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        context: context,
        builder: (context) {
          return AddTaskBox(controller: _controller);
        }).then((value) {
      //Add new Task here -- to database
      debugPrint(value);
      _controller.text = "";
    });
  }

  void handleClick(String value) {
    switch (value) {
      case 'Unlist':
        debugPrint("Unlist");
        break;
      case 'Edit':
        navigatePush(context, "/edit_teams");
        break;
      case 'Disband':
        debugPrint("Disband");
        break;
    }
  }

  Widget manageTask(taskName, state, teamCubit) {
    return Column(children: [
      const SizedBox(height: 15),
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
        child: Row(
          children: [
            Checkbox(
              value: state.isChecked,
              onChanged: (bool? value) {
                setState(() {
                  teamCubit.setIsCheckedState(value!);
                });
              },
              activeColor: yellowColor,
            ),
            // task name
            Text(
              taskName,
              style: TextStyle(
                decoration: state.isChecked
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ],
        ),
      )
    ]);
  } //addTask
}
