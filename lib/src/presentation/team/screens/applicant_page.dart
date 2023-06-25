import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/team/cubits/applicant_cubit.dart';
import 'package:launchlab/src/presentation/team/widgets/applicant_confirmation.dart';
import 'package:launchlab/src/utils/helper.dart';

class ApplicantPage extends StatefulWidget {
  final String applicationID;
  const ApplicantPage({super.key, required this.applicationID});

  @override
  State<ApplicantPage> createState() => _ApplicantPageState();
}

class _ApplicantPageState extends State<ApplicantPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => ApplicantCubit(),
        child: BlocBuilder<ApplicantCubit, ApplicantState>(
            builder: (context, state) {
          final applicantCubit = BlocProvider.of<ApplicantCubit>(context);

          return FutureBuilder(
              future: applicantCubit.getData(widget.applicationID),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  Map applicantUserData = snapshot.data[0][0];
                  Map applicationTeamData = snapshot.data[1][0];
                  List experienceData = snapshot.data[2];
                  List accomplishmentData = snapshot.data[3];
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      iconTheme: const IconThemeData(color: blackColor),
                    ),
                    body: Stack(children: [
                      Column(children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 10),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [headerText("Requests")]),
                                    const SizedBox(height: 20),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: whiteColor,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 3,
                                              blurRadius: 3,
                                              offset: const Offset(0, 3),
                                            )
                                          ]),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            applicantUserData['avatar_url'] ==
                                                    ''
                                                ? Image.asset(
                                                    'assets/images/avatar_temp.png')
                                                : Image.network(
                                                    applicantUserData[
                                                        'avatar_url']),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    headerText(
                                                        "${applicantUserData['first_name']} ${applicantUserData['last_name']}",
                                                        size: 27.0),
                                                    bodyText(applicantUserData[
                                                        'title']),
                                                    bodyText(
                                                        applicantUserData[
                                                                'degree_programmes']
                                                            ['name'],
                                                        color: greyColor),
                                                  ]),
                                            ),
                                          ]),
                                    ),
                                    const SizedBox(height: 40),
                                    subHeaderText('About Me'),
                                    bodyText(applicantUserData['about']),
                                    const SizedBox(height: 40),
                                    //subHeaderText('Resume'),
                                    //bodyText('Placeholder'),
                                    //const SizedBox(height: 40),
                                    experienceData.isEmpty
                                        ? const SizedBox()
                                        : Column(children: [
                                            subHeaderText('Experience'),
                                            const SizedBox(height: 10),
                                            for (int i = 0;
                                                i < experienceData.length;
                                                i++) ...[
                                              experienceDisplay(
                                                  experienceData[i])
                                            ],
                                            const SizedBox(height: 40),
                                          ]),
                                    //subHeaderText('Skills'),
                                    //bodyText('Placeholder'),
                                    //const SizedBox(height: 40),
                                    accomplishmentData.isEmpty
                                        ? const SizedBox()
                                        : Column(children: [
                                            subHeaderText('Achievement'),
                                            const SizedBox(height: 10),
                                            for (int i = 0;
                                                i < accomplishmentData.length;
                                                i++) ...[
                                              achievementDisplay(
                                                  accomplishmentData[i])
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
                                      _rejectConfirmationBox(
                                          context, applicantCubit);
                                    },
                                    backgroundColor: whiteColor,
                                    child: const Icon(Icons.close,
                                        color: blackColor),
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
                                      applicationTeamData['current_members'] <
                                              applicationTeamData['max_members']
                                          ? _acceptanceConfirmationBox(
                                              context,
                                              applicantCubit,
                                              applicationTeamData[
                                                  'current_members'])
                                          : confirmationBox(
                                              context,
                                              "Your team is full.",
                                              "Increase the max size of your team or remove a member!");
                                    },
                                    backgroundColor: whiteColor,
                                    child: const Icon(Icons.check,
                                        color: blackColor),
                                  ),
                                ]),
                            const SizedBox(height: 40),
                          ])
                    ]),
                  );
                } else {
                  return futureBuilderFail(() => setState(() {}));
                }
              });
        }));
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
        cubit.rejectApplicant(applicationID: widget.applicationID);
        navigatePop(context);
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
        cubit.acceptApplicant(
            applicationID: widget.applicationID, currentMember: currentMember);
        navigatePop(context);
      }
    });
  }

  Widget experienceDisplay(experienceData) {
    return IntrinsicHeight(
      child: Row(children: <Widget>[
        Container(
          width: 1,
          height: double.infinity,
          color: blackColor,
          margin: const EdgeInsets.only(right: 15),
        ),
        Flexible(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            bodyText(
                "${stringToDateFormatter(experienceData['start_date'], noDate: true)} - ${experienceData['is_current'] ? 'Present' : stringToDateFormatter(experienceData['end_date'], noDate: true)}",
                color: greyColor,
                size: 15.0),
            subHeaderText(experienceData['title'], size: 15.0),
            bodyText(experienceData['company_name'], size: 15.0),
            const SizedBox(height: 8),
            bodyText(experienceData['description'], size: 14.0),
            const SizedBox(height: 30),
          ]),
        )
      ]),
    );
  }

  Widget achievementDisplay(accomplishmentData) {
    return IntrinsicHeight(
        child: Row(children: <Widget>[
      Container(
        width: 1,
        height: double.infinity,
        color: blackColor,
        margin: const EdgeInsets.only(right: 15),
      ),
      Flexible(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          bodyText(
              "${stringToDateFormatter(accomplishmentData['start_date'], noDate: true)} - ${accomplishmentData['is_active'] ? 'Present' : stringToDateFormatter(accomplishmentData['end_date'], noDate: true)}",
              color: greyColor,
              size: 15.0),
          subHeaderText(accomplishmentData['title'], size: 15.0),
          bodyText(accomplishmentData['issuer'], size: 15.0),
          const SizedBox(height: 8),
          bodyText(accomplishmentData['description'], size: 14.0),
          const SizedBox(height: 30),
        ]),
      ),
    ]));
  }
}
