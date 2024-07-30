import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/text/ll_body_text.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/utils/helper.dart';

class AccomplishmentList extends StatelessWidget {
  const AccomplishmentList({
    super.key,
    required this.accomplishments,
    required this.onAddHandler,
    required this.onEditHandler,
    this.isOnboardMode = true,
  });

  final List<AccomplishmentEntity> accomplishments;
  final Future<void> Function() onAddHandler;
  final Future<void> Function(AccomplishmentEntity) onEditHandler;
  final bool isOnboardMode;

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
                    onTapHandler: (context, acc) => onEditHandler(acc),
                  ))
              .toList();
        }(),
        ...() {
          if (isOnboardMode) {
            return [
              LimitedBox(
                maxWidth: 100,
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: blackColor,
                    ),
                    onPressed: () {
                      onAddHandler();
                    },
                    child: const LLBodyText(label: "Add", color: whiteColor)),
              )
            ];
          }
          return [];
        }(),
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
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5.0),
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
                        "${dateStringFormatter("dd MMM yyyy", accomplishment.startDate)} - ${accomplishment.endDate != null ? dateStringFormatter("dd MMM yyyy", accomplishment.endDate!) : "Present"}"),
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
