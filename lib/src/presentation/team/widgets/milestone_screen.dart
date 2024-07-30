import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/team/milestone_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/text/ll_body_text.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class MilestoneScreen extends StatefulWidget {
  final MilestoneEntity milestone;
  const MilestoneScreen({super.key, required this.milestone});

  @override
  State<MilestoneScreen> createState() => _MilestoneScreenState();
}

class _MilestoneScreenState extends State<MilestoneScreen> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: lightGreyColor,
      content: SizedBox(
        width: 1000000,
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(children: [
                  Image.asset("assets/images/yellow_curve_shape_4.png"),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 30.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: subHeaderText(widget.milestone.title,
                                  maxLines: 5)),
                          const SizedBox(height: 20),
                          widget.milestone.description == ''
                              ? const SizedBox()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      subHeaderText('Description', size: 15.0),
                                      const SizedBox(height: 3),
                                      LLBodyText(label: widget.milestone.description),
                                      const SizedBox(height: 15)
                                    ]),
                          boldFirstText('Start Date: ',
                              dateToDateFormatter((widget.milestone.startDate)),
                              size: 15.0),
                          const SizedBox(height: 5),
                          boldFirstText('End Date:   ',
                              dateToDateFormatter((widget.milestone.endDate)),
                              size: 15.0),
                        ]),
                  ),
                ]),
                OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const LLBodyText(label: "Close")),
                const SizedBox(height: 20),
              ]),
        ),
      ),
    );
  }
}
