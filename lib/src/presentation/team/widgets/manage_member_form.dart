import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

// ignore: must_be_immutable
class ManageMemberBox extends StatelessWidget {
  VoidCallback onClose;

  ManageMemberBox({
    super.key,
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
                      manageMemberBar(
                          "circle_profile_pic.png", "John Doe", "CEO"),
                      manageMemberBar("circle_profile_pic.png", "hi", "hi"),
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
