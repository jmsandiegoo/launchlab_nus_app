import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/user/screens/profile_manage_accomplishment_page.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';

class ProfileAccomplishmentList extends StatelessWidget {
  const ProfileAccomplishmentList({
    super.key,
    this.isAuthProfile = false,
    required this.accomplishments,
    required this.onUpdateHandler,
  });

  final bool isAuthProfile;
  final List<AccomplishmentEntity> accomplishments;
  final void Function() onUpdateHandler;

  Future<void> manageAccomplishment(
      BuildContext context, ProfileManageAccomplishmentPageProps props) async {
    final NavigationData<Object?>? returnData =
        await navigatePushWithData<Object?>(
      context,
      "/profile/manage-accomplishment",
      props,
    );

    if (returnData == null || returnData.actionType == ActionTypes.cancel) {
      return;
    }

    if (returnData.actionType == ActionTypes.update) {
      onUpdateHandler();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isAuthProfile && accomplishments.isEmpty) {
      return const SizedBox(
        height: 0,
        width: 0,
      );
    }

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
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            subHeaderText("Accomplishment"),
            ...() {
              if (!isAuthProfile) {
                return [
                  const SizedBox(height: 45.0),
                ];
              }

              return [
                IconButton(
                  onPressed: () {
                    manageAccomplishment(
                        context,
                        ProfileManageAccomplishmentPageProps(
                            userAccomplishments: accomplishments));
                  },
                  icon: const Icon(Icons.edit_outlined, color: blackColor),
                ),
              ];
            }(),
          ],
        ),
        const SizedBox(height: 5),
        IntrinsicHeight(
          child: Row(
            children: <Widget>[
              Container(
                width: 1,
                height: double.infinity,
                color: blackColor,
                margin: const EdgeInsets.only(top: 10, right: 15),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...() {
                      if (sortedAccomplishments.isEmpty) {
                        return [bodyText("No accomplishments stated.")];
                      }
                      return sortedAccomplishments
                          .map((item) =>
                              AccomplishmentWidget(accomplishment: item))
                          .toList();
                    }(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AccomplishmentWidget extends StatelessWidget {
  const AccomplishmentWidget({super.key, required this.accomplishment});

  final AccomplishmentEntity accomplishment;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5.0),
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
                      "${dateStringFormatter("dd MMM yyyy", accomplishment.startDate)} - ${accomplishment.endDate != null ? dateStringFormatter("dd MMM yyyy", accomplishment.endDate!) : "Present"}",
                      color: greyColor.shade700),
                  const SizedBox(height: 1.0),
                  smallText(accomplishment.title, weight: FontWeight.w600),
                  const SizedBox(height: 1.0),
                ],
              ),
            ],
          ),
          smallText(accomplishment.issuer),
          const SizedBox(height: 5.0),
          smallText(accomplishment.description!),
        ],
      ),
    );
  }
}
