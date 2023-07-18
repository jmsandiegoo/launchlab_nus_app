import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/domain/team/team_applicant_entity.dart';
import 'package:launchlab/src/domain/team/team_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/team/cubits/applicant_cubit.dart';
import 'package:launchlab/src/presentation/team/widgets/applicant_accomplishment.dart';
import 'package:launchlab/src/presentation/team/widgets/applicant_confirmation.dart';
import 'package:launchlab/src/presentation/team/widgets/applicant_experience.dart';
import 'package:launchlab/src/presentation/team/widgets/applicant_resume.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';

class ApplicantPage extends StatelessWidget {
  final TeamApplicantEntity applicantData;

  const ApplicantPage({super.key, required this.applicantData});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ApplicantCubit(TeamRepository()),
      child: ApplicantPageContent(applicantData: applicantData),
    );
  }
}

class ApplicantPageContent extends StatefulWidget {
  final TeamApplicantEntity applicantData;
  const ApplicantPageContent({super.key, required this.applicantData});

  @override
  State<ApplicantPageContent> createState() => _ApplicantPageContentState();
}

class _ApplicantPageContentState extends State<ApplicantPageContent> {
  late ApplicantCubit applicantCubit;
  late TeamEntity applicationTeamData;

  @override
  void initState() {
    super.initState();
    applicantCubit = BlocProvider.of<ApplicantCubit>(context);
    applicantCubit.getData(widget.applicantData.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicantCubit, ApplicantState>(
        builder: (context, state) {
      if (applicantCubit.state.status == ApplicantStatus.success) {
        applicationTeamData = applicantCubit.state.applicationTeamData!;
      }

      return applicantCubit.state.status == ApplicantStatus.success
          ? Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: blackColor),
                  onPressed: () => navigatePop(context),
                ),
              ),
              body: Stack(children: [
                Column(children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 10),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [headerText("Requests")]),
                              const SizedBox(height: 20),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 3,
                                        offset: const Offset(0, 3),
                                      )
                                    ]),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      widget.applicantData.getAvatarURL() ==
                                              null
                                          ? Image.asset(
                                              'assets/images/avatar_temp.png')
                                          : Image.network(widget.applicantData
                                              .getAvatarURL()!),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              headerText(
                                                  widget.applicantData
                                                      .getFullName(),
                                                  size: 27.0),
                                              bodyText(widget
                                                  .applicantData.user.title!),
                                              bodyText(
                                                  widget
                                                      .applicantData
                                                      .user
                                                      .userDegreeProgramme!
                                                      .name,
                                                  color: greyColor),
                                            ]),
                                      ),
                                    ]),
                              ),
                              const SizedBox(height: 40),
                              subHeaderText('About Me'),
                              bodyText(widget.applicantData.user.about!),
                              const SizedBox(height: 40),
                              widget.applicantData.user.userResume == null
                                  ? const SizedBox()
                                  : Column(children: [
                                      subHeaderText('Resume'),
                                      ApplicantResume(
                                          resume: widget
                                              .applicantData.user.userResume!),
                                      const SizedBox(height: 40)
                                    ]),
                              widget.applicantData.user.userExperiences.isEmpty
                                  ? const SizedBox()
                                  : Column(children: [
                                      subHeaderText('Experience'),
                                      const SizedBox(height: 10),
                                      for (int i = 0;
                                          i <
                                              widget.applicantData.user
                                                  .userExperiences.length;
                                          i++) ...[
                                        ApplicantExperience(
                                            experienceData: widget.applicantData
                                                .user.userExperiences[i]),
                                      ],
                                      const SizedBox(height: 40),
                                    ]),
                              subHeaderText('Skills'),
                              Container(
                                alignment: Alignment.topLeft,
                                child: chipsWrap(widget.applicantData.user
                                    .userPreference!.skillsInterests),
                              ),
                              const SizedBox(height: 40),
                              widget.applicantData.user.userAccomplishments
                                      .isEmpty
                                  ? const SizedBox()
                                  : Column(children: [
                                      subHeaderText('Achievement'),
                                      const SizedBox(height: 10),
                                      for (int i = 0;
                                          i <
                                              widget.applicantData.user
                                                  .userAccomplishments.length;
                                          i++) ...[
                                        ApplicantAccomplishment(
                                            accomplishmentData: widget
                                                .applicantData
                                                .user
                                                .userAccomplishments[i]),
                                      ],
                                      const SizedBox(height: 40)
                                    ]),
                              const SizedBox(height: 110),
                            ]),
                      ),
                    ),
                  ),
                ]),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FloatingActionButton(
                              onPressed: () {
                                _rejectConfirmationBox(context, applicantCubit);
                              },
                              backgroundColor: whiteColor,
                              child: const Icon(Icons.close, color: blackColor),
                            ),
                            const SizedBox(width: 25),
                            FloatingActionButton(
                              onPressed: () {},
                              backgroundColor: yellowColor,
                              child: const Icon(Icons.chat_bubble_outline,
                                  color: blackColor),
                            ),
                            const SizedBox(width: 25),
                            FloatingActionButton(
                              onPressed: () {
                                applicationTeamData.currentMembers <
                                        applicationTeamData.maxMembers
                                    ? _acceptanceConfirmationBox(
                                        context,
                                        applicantCubit,
                                        applicationTeamData.currentMembers)
                                    : confirmationBox(
                                        context,
                                        "Your team is full.",
                                        "Increase the max size of your team or remove a member!");
                              },
                              backgroundColor: whiteColor,
                              child: const Icon(Icons.check, color: blackColor),
                            ),
                          ]),
                      const SizedBox(height: 40),
                    ])
              ]),
            )
          : const Center(child: CircularProgressIndicator());
    });
  }

  void _rejectConfirmationBox(context, cubit) {
    showDialog(
        context: context,
        builder: (context) {
          return ApplicationConfirmationBox(
            title: 'Are you sure?',
            message:
                'Are you sure that you want to reject this applicant? \n\nThis cannot be undone.',
            onClose: () => Navigator.pop(context),
          );
        }).then((value) {
      if (value == true) {
        cubit.rejectApplicant(applicationID: widget.applicantData.id).then((_) {
          navigatePopWithData(context, "", ActionTypes.delete);
        });
      }
    });
  }

  void _acceptanceConfirmationBox(context, cubit, currentMember) {
    showDialog(
        context: context,
        builder: (context) {
          return ApplicationConfirmationBox(
            title: 'Are you sure?',
            message: 'Are you sure that you want to accept this applicant?',
            onClose: () => Navigator.pop(context),
          );
        }).then((value) {
      if (value == true) {
        cubit
            .acceptApplicant(
                applicationID: widget.applicantData.id,
                currentMember: currentMember)
            .then((_) {
          navigatePopWithData(context, "", ActionTypes.update);
        });
      }
    });
  }
}
