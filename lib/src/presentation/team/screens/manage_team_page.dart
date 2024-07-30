import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/team/role_entity.dart';
import 'package:launchlab/src/domain/team/team_applicant_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/text/ll_body_text.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/team/cubits/manage_team_cubit.dart';
import 'package:launchlab/src/presentation/team/widgets/applicant_card.dart';
import 'package:launchlab/src/presentation/team/widgets/manage_roles_form.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageTeamPage extends StatelessWidget {
  final String teamId;

  const ManageTeamPage({super.key, required this.teamId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => ManageTeamCubit(
            TeamRepository(), UserRepository(Supabase.instance)),
        child: ManageTeamContent(teamId: teamId));
  }
}

class ManageTeamContent extends StatefulWidget {
  final String teamId;
  const ManageTeamContent({super.key, required this.teamId});

  @override
  State<ManageTeamContent> createState() => _ManageTeamState();
}

class _ManageTeamState extends State<ManageTeamContent> {
  late ManageTeamCubit manageTeamCubit;
  late List<RoleEntity> rolesData;
  late List<TeamApplicantEntity> applicantUserData;
  ActionTypes actionType = ActionTypes.cancel;

  @override
  void initState() {
    super.initState();
    manageTeamCubit = BlocProvider.of<ManageTeamCubit>(context);
    manageTeamCubit.getData(widget.teamId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageTeamCubit, ManageTeamState>(
        builder: (context, state) {
      if (manageTeamCubit.state.status == ManageTeamStatus.success) {
        rolesData = manageTeamCubit.state.rolesData;
        applicantUserData = manageTeamCubit.state.applicantUserData;
      }

      return RefreshIndicator(
          onRefresh: () async {
            refreshPage();
          },
          child: manageTeamCubit.state.status == ManageTeamStatus.success
              ? Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: blackColor),
                      onPressed: () =>
                          navigatePopWithData(context, '', actionType),
                    ),
                  ),
                  body: ListView(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        headerText("Manage Team"),
                                        const LLBodyText(
                                            label:
                                                "Create new roles and \nmanage applicants here!")
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Expanded(
                                    flex: 2,
                                    child: SvgPicture.asset(
                                        'assets/images/create_team.svg'),
                                  ),
                                ]),

                            const SizedBox(height: 20),

                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  subHeaderText("Roles"),
                                  GestureDetector(
                                      onTap: () {
                                        _manageRoles("", "");
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
                                          subHeaderText(rolesData[i].title,
                                              size: 15.0),
                                          overflowText(
                                              rolesData[i].description),
                                        ])),
                                    IconButton(
                                      onPressed: () {
                                        _manageRoles(rolesData[i].title,
                                            rolesData[i].description,
                                            roleId: rolesData[i].id);
                                      },
                                      icon: const Icon(Icons.edit_outlined),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        manageTeamCubit.deleteRoles(
                                            roleId: rolesData[i].id);
                                        refreshPage();
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
                                              "/team-home/teams/manage_teams/applicants",
                                              applicantUserData[i])
                                          .then((value) {
                                        if (value?.actionType ==
                                            ActionTypes.update) {
                                          refreshPage();
                                          actionType = ActionTypes.update;
                                        }
                                        if (value?.actionType ==
                                            ActionTypes.delete) {
                                          refreshPage();
                                        }
                                      });
                                    },
                                    child: ApplicantCard(
                                        applicantData:
                                            applicantUserData[i].user)),
                              ]
                            ])
                          ]),
                    ),
                  ]),
                )
              : const Center(child: CircularProgressIndicator()));
    });
  }

  void refreshPage() {
    manageTeamCubit.loading();
    manageTeamCubit.getData(widget.teamId);
  }

  void _manageRoles(title, description, {roleId = ''}) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        context: context,
        builder: (context) {
          return ManageRolesBox(
            title: title,
            description: description,
          );
        }).then((output) {
      if (output != null && roleId == '') {
        manageTeamCubit.addRoles(
            teamId: widget.teamId, title: output[0], description: output[1]);
        manageTeamCubit.getData(widget.teamId);
      } else if (output != null) {
        manageTeamCubit.updateRoles(
            roleId: roleId, title: output[0], description: output[1]);
        manageTeamCubit.getData(widget.teamId);
      }
    });
  }
}
