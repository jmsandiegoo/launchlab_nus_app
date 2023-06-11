import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/utils/helper.dart';

class AccomplishmentList extends StatelessWidget {
  const AccomplishmentList({super.key, required this.accomplishments});

  final List<AccomplishmentEntity> accomplishments;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...() {
          return accomplishments
              .map((item) => AccomplishmentCard(
                    accomplishment: item,
                  ))
              .toList();
        }(),
        LimitedBox(
          maxWidth: 100,
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: blackColor,
              ),
              onPressed: () => navigatePush(context, "/add-accomplishment"),
              child: bodyText("Add", color: whiteColor)),
        )
      ],
    );
  }
}

class AccomplishmentCard extends StatelessWidget {
  const AccomplishmentCard({super.key, required this.accomplishment});

  final AccomplishmentEntity accomplishment;

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
                        "${dateStringFormatter("MMM yyyy", accomplishment.startDate)} — ${dateStringFormatter("MMM yyyy", accomplishment.endDate!)}"),
                    const SizedBox(height: 1.0),
                    smallText(accomplishment.title, weight: FontWeight.w600),
                    const SizedBox(height: 1.0),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    navigatePush(context, "/edit-accomplishment");
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
