// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/team/cubits/manage_team_cubit.dart';
import 'package:launchlab/src/presentation/team/widgets/manage_roles_form.dart';
import 'package:launchlab/src/utils/helper.dart';

class ManageTeamPage extends StatefulWidget {
  final String teamId;

  const ManageTeamPage({super.key, required this.teamId});

  @override
  State<ManageTeamPage> createState() => _ManageTeamPageState(teamId);
}

class _ManageTeamPageState extends State<ManageTeamPage> {
  _ManageTeamPageState(this.teamId);
  final String teamId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => ManageTeamCubit(),
        child: BlocBuilder<ManageTeamCubit, ManageTeamState>(
            builder: (context, state) {
          final manageTeamCubit = BlocProvider.of<ManageTeamCubit>(context);
          return FutureBuilder(
              future: manageTeamCubit.getData(teamId),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  final List applicantUserData = snapshot.data[0];
                  final List rolesData = snapshot.data[1];

                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      iconTheme: const IconThemeData(color: blackColor),
                    ),
                    body: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 20),
                                        headerText("Manage Team"),
                                        bodyText(
                                            "Create new roles and \nmanage applicants here!")
                                      ],
                                    ),
                                    SizedBox(
                                        height: 150,
                                        child: SvgPicture.asset(
                                            'assets/images/create_team.svg'))
                                  ]),

                              //Add the remaining details here.
                              const SizedBox(height: 20),

                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    subHeaderText("Roles"),
                                    GestureDetector(
                                        onTap: () {
                                          _manageRoles("", "", manageTeamCubit);
                                        },
                                        child: subHeaderText("Add Role +",
                                            size: 13.0))
                                  ]),
                              for (int i = 0; i < rolesData.length; i++) ...[
                                const SizedBox(height: 10),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                            subHeaderText(rolesData[i]['title'],
                                                size: 15.0),
                                            overflowText(
                                                rolesData[i]['description']),
                                          ])),
                                      IconButton(
                                        onPressed: () {
                                          _manageRoles(
                                              rolesData[i]['title'],
                                              rolesData[i]['description'],
                                              manageTeamCubit,
                                              roleId: rolesData[i]['id']);
                                        },
                                        icon: const Icon(Icons.edit_outlined),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          manageTeamCubit.deleteRoles(
                                              roleId: rolesData[i]['id']);
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.delete_outline),
                                      ),
                                    ]),
                                const SizedBox(height: 10),
                              ],
                              //Applicants
                              const SizedBox(height: 50),
                              subHeaderText('Applicants'),
                              Column(children: [
                                for (int i = 0;
                                    i < applicantUserData.length;
                                    i++) ...[
                                  const SizedBox(height: 20),
                                  GestureDetector(
                                      onTap: () {
                                        navigatePushWithData(
                                            context,
                                            "/applicants",
                                            applicantUserData[i]
                                                    ['team_applicants'][0]['id']
                                                .toString());
                                      },
                                      child:
                                          _applicantCard(applicantUserData[i])),
                                ]
                              ])
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

  Widget _applicantCard(applicantData) {
    return Container(
      width: double.infinity,
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
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Row(children: [
            profilePicture(40.0, applicantData['avatar_url'], isUrl: true),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                subHeaderText(
                    "${applicantData['first_name']} ${applicantData['last_name']}",
                    size: 16.0),
                bodyText(applicantData['title'], size: 13.0)
              ],
            )
          ]),
        ]),
      ),
    );
  }

  void _manageRoles(title, description, cubit, {roleId = ''}) {
    showModalBottomSheet(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        context: context,
        builder: (context) {
          return ManageRolesBox(
            title: title,
            description: description,
          );
        }).then((output) {
      if (output != null && roleId == '') {
        cubit.addRoles(
            teamId: teamId, title: output[0], description: output[1]);
        setState(() {});
      } else if (output != null) {
        cubit.updateRoles(
            roleId: roleId, title: output[0], description: output[1]);
        setState(() {});
      }
    });
  }
}
