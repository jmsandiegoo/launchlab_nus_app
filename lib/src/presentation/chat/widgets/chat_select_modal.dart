import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/multi_button_select.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class ChatSelectModal extends StatelessWidget {
  const ChatSelectModal({
    super.key,
    required this.onClose,
  });

  final void Function() onClose;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: lightGreyColor,
      child: Stack(
        children: [
          Image.asset("assets/images/chat_select_bg.png"),
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Image.asset(
                        "assets/images/chat_select.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(Icons.forum_outlined),
                              subHeaderText(" Select Chats",
                                  alignment: TextAlign.right),
                            ])),
                  ],
                ),
                TextFieldWidget(
                    focusNode: FocusNode(),
                    onChangedHandler: (val) {},
                    label: "",
                    value: "",
                    hint: "Search a Team",
                    controller: TextEditingController()),
                MultiButtonSingleSelectWidget<String>(
                    itemRatio: (1 / .3),
                    value: "Leading",
                    options: const ["Leading", "Participating", "Applications"],
                    colNo: 3,
                    onPressHandler: (val) {}),
                Expanded(
                  child: ListView(),
                ),
                SizedBox(
                  width: 150,
                  child: outlinedButton(
                      label: "Close",
                      onPressedHandler: onClose,
                      color: blackColor),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
