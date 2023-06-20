import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class ManageMemberBox extends StatelessWidget {
  final VoidCallback onClose;
  final List memberData;

  const ManageMemberBox({
    super.key,
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
                                height: 50,
                                child: SvgPicture.asset(
                                    'assets/images/add_member.svg'))
                          ]),
                      for (int i = 0; i < memberData.length; i++) ...[
                        manageMemberBar(
                            "circle_profile_pic.png",
                            "${memberData[i]['users']['first_name']} ${memberData[i]['users']['last_name']}",
                            memberData[i]['position'])
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
}
