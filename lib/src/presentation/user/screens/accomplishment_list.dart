import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';

class AccomplishmentList extends StatelessWidget {
  const AccomplishmentList(
      {super.key,
      required this.accomplishments,
      required this.onChangedHandler});

  final List<AccomplishmentEntity> accomplishments;
  final void Function(List<AccomplishmentEntity>) onChangedHandler;

  Future<void> addAccomplishment(BuildContext context) async {
    final returnData =
        await navigatePush(context, "/onboard-add-accomplishment");

    if (returnData == null) {
      return;
    }

    if (returnData.actionType == ActionTypes.create) {
      final newAccomplishments = [...accomplishments];
      newAccomplishments.add(returnData.data);
      onChangedHandler(newAccomplishments);
    }
  }

  Future<void> editAccomplishment(
      BuildContext context, AccomplishmentEntity acc) async {
    final NavigationData<AccomplishmentEntity>? returnData =
        await navigatePushWithData<AccomplishmentEntity>(
            context, "/onboard-edit-accomplishment", acc);

    List<AccomplishmentEntity> newAccomplishments = [...accomplishments];
    final index = newAccomplishments.indexOf(acc);

    if (returnData == null) {
      return;
    }

    if (returnData.actionType == ActionTypes.update) {
      newAccomplishments[index] = returnData.data!;
      onChangedHandler(newAccomplishments);
    }

    if (returnData.actionType == ActionTypes.delete) {
      newAccomplishments.removeAt(index);
      onChangedHandler(newAccomplishments);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<AccomplishmentEntity> sortedAccomplishments = [...accomplishments];

    sortedAccomplishments.sort((acc1, acc2) {
      if (acc1 == acc2) {
        return 0;
      }

      if (acc1.isActive && !acc2.isActive) {
        return -1;
      } else if (!acc1.isActive && acc2.isActive) {
        return 1;
      } else if (acc1.isActive && acc2.isActive) {
        return acc1.startDate.compareTo(acc2.startDate);
      } else {
        return acc1.endDate!.compareTo(acc2.endDate!);
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...() {
          return sortedAccomplishments
              .map((item) => AccomplishmentCard(
                    accomplishment: item,
                    onTapHandler: (context, acc) =>
                        editAccomplishment(context, acc),
                  ))
              .toList();
        }(),
        LimitedBox(
          maxWidth: 100,
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: blackColor,
              ),
              onPressed: () {
                addAccomplishment(context);
              },
              child: bodyText("Add", color: whiteColor)),
        )
      ],
    );
  }
}

class AccomplishmentCard extends StatelessWidget {
  const AccomplishmentCard(
      {super.key, required this.accomplishment, required this.onTapHandler});

  final AccomplishmentEntity accomplishment;
  final void Function(BuildContext, AccomplishmentEntity) onTapHandler;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    smallText(
                        "${dateStringFormatter("MMM yyyy", accomplishment.startDate)} - ${accomplishment.endDate != null ? dateStringFormatter("MMM yyyy", accomplishment.endDate!) : "Present"}"),
                    const SizedBox(height: 1.0),
                    smallText(accomplishment.title, weight: FontWeight.w600),
                    const SizedBox(height: 1.0),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    onTapHandler(context, accomplishment);
                  },
                  child: const Icon(
                    Icons.edit_outlined,
                  ),
                )
              ],
            ),
            smallText(accomplishment.issuer),
            const SizedBox(height: 5.0),
            ...(() => accomplishment.description != null
                ? [smallText(accomplishment.description!)]
                : [])(),
          ],
        ),
      ),
    );
  }
}
