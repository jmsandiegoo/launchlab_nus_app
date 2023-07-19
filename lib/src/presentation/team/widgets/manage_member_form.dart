import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/team/team_user_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageMemberBox extends StatelessWidget {
  final bool isOwner;
  final List<TeamUserEntity> memberData;
  final VoidCallback onClose;

  const ManageMemberBox({
    super.key,
    required this.isOwner,
    required this.memberData,
    required this.onClose,
  });

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
                    child: Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            subHeaderText("Team Member"),
                            SizedBox(
                                height: 35,
                                child: SvgPicture.asset(
                                    'assets/images/add_member.svg'))
                          ]),
                      for (int i = 0; i < memberData.length; i++) ...[
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              Supabase.instance.client.auth.currentUser!.id ==
                                      memberData[i].user.id
                                  ? navigateGo(context, '/profile')
                                  : context.push(
                                      "/profile/${memberData[i].user.id}");
                            },
                            child: manageMemberBar(
                                memberData[i].getAvatarURL(),
                                memberData[i].getFullName(),
                                memberData[i].positon,
                                memberData[i].id,
                                context))
                      ]
                    ]),
                  ),
                ]),
                OutlinedButton(onPressed: onClose, child: bodyText("Close")),
                const SizedBox(height: 20),
              ]),
        ),
      ),
    );
  }

  Widget manageMemberBar(imgDir, name, position, memberId, context) {
    void manageMember(String value) {
      switch (value) {
        case 'Remove':
          Navigator.of(context).pop([ActionTypes.delete, memberId]);
          break;

        case 'Edit':
          Navigator.of(context).pop([ActionTypes.update, memberId]);
          break;
      }
    }

    return Column(children: [
      const SizedBox(height: 20),
      Container(
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
          padding: const EdgeInsets.fromLTRB(8.0, 0, 5.0, 8.0),
          child: Column(children: [
            if (position == 'Owner') ...[
              memberProfile(imgDir, name, position,
                  imgSize: 35.0, isBold: true),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  memberProfile(imgDir, name, position,
                      imgSize: 35.0, isBold: true),
                  isOwner
                      ? PopupMenuButton<String>(
                          onSelected: manageMember,
                          itemBuilder: (BuildContext context) {
                            return {'Remove'}.map((String choice) {
                              return PopupMenuItem<String>(
                                  value: choice, child: Text(choice));
                            }).toList();
                          },
                        )
                      : const SizedBox()
                ],
              )
            ],
          ]),
        ),
      ),
    ]);
  }
}
