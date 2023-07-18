import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/team/milestone_entity.dart';
import 'package:launchlab/src/presentation/team/cubits/team_cubit.dart';
import 'package:launchlab/src/presentation/team/widgets/add_task.dart';
import 'package:launchlab/src/utils/constants.dart';

class MilestoneCard extends StatefulWidget {
  final MilestoneEntity milestoneData;
  final bool isOwner;
  final TeamCubit teamCubit;
  final String teamId;
  const MilestoneCard(
      {super.key,
      required this.milestoneData,
      required this.isOwner,
      required this.teamCubit,
      required this.teamId});

  @override
  State<MilestoneCard> createState() => _MilestoneCardState();
}

class _MilestoneCardState extends State<MilestoneCard> {
  @override
  Widget build(BuildContext context) {
    bool isChecked = widget.milestoneData.isCompleted;
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
                widget.teamCubit
                    .saveMilestoneData(
                        val: value, taskId: widget.milestoneData.id)
                    .then((_) {
                  widget.teamCubit.getData(widget.teamId);
                });
                setState(() {
                  isChecked = value!;
                });
              },
              activeColor: yellowColor,
            ),
            SizedBox(
              width: 200,
              child: Text(
                widget.milestoneData.title,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                  decoration: widget.milestoneData.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
          ]),
          widget.isOwner
              ? Flexible(
                  flex: 1,
                  child: PopupMenuButton<String>(
                    onSelected: manageTask,
                    itemBuilder: (BuildContext context) {
                      return {'Edit', 'Delete'}.map((String choice) {
                        return PopupMenuItem<String>(
                            value: choice, child: Text(choice));
                      }).toList();
                    },
                  ),
                )
              : const SizedBox(),
          const SizedBox(width: 5)
        ]),
      )
    ]);
  }

  void manageTask(String value) {
    switch (value) {
      case 'Delete':
        widget.teamCubit.deleteMilestone(taskId: widget.milestoneData.id);
        widget.teamCubit.getData(widget.teamId);
        break;
      case 'Edit':
        _addEditTask(
            milestone: widget.milestoneData, actionType: ActionTypes.update);
    }
  }

  void _addEditTask({milestone, actionType}) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        context: context,
        builder: (context) {
          return AddTaskBox(
              taskTitle: widget.milestoneData.title,
              startDate: widget.milestoneData.startDate.toString(),
              endDate: widget.milestoneData.endDate.toString(),
              description: widget.milestoneData.description,
              actionType: actionType);
        }).then((output) {
      //Add new Task here -- to database
      if (output != null) {
        if (actionType == ActionTypes.update) {
          widget.teamCubit.editMilestone(
              taskId: widget.milestoneData.id,
              title: output[0],
              startDate: output[1],
              endDate: output[2],
              description: output[3]);
        }
        widget.teamCubit.getData(widget.teamId);
      }
    });
  }
}
