import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/chat/widgets/chat_select_modal.dart';
import 'package:launchlab/src/presentation/chat/widgets/team_chat_list.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/multi_button_select.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key, this.teamId});

  final String? teamId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          AppBar(
            titleSpacing: 0,
            centerTitle: false,
            backgroundColor: Colors.transparent,
            title: GestureDetector(
              onTap: () => showDialog(
                  context: context,
                  builder: (context) {
                    return ChatSelectModal(
                      onClose: () => Navigator.pop(context),
                    );
                  }),
              child: Container(
                  decoration: BoxDecoration(
                      color: yellowColor,
                      borderRadius: BorderRadius.circular(5.0)),
                  padding: const EdgeInsets.all(15.0),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    subHeaderText("Web 3.0 Startup", size: 15.0),
                    const Icon(
                      Icons.expand_more_outlined,
                      weight: 100,
                    )
                  ])),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    context
                        .push("/profile/209b2b56-6156-42bc-91ee-4b20d5632ce3");
                  },
                  icon: const Icon(Icons.waving_hand_outlined)),
              IconButton(onPressed: () {}, icon: Icon(Icons.info_outline))
            ],
          ),
          const SizedBox(
            height: 50.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.chat_bubble_outline),
              headerText("  Chats"),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextFieldWidget(
              focusNode: FocusNode(),
              onChangedHandler: (val) {},
              label: "",
              value: "",
              hint: "Search Chat",
              controller: TextEditingController()),
          const SizedBox(
            height: 10.0,
          ),
          MultiButtonSingleSelectWidget<String>(
              itemRatio: (1 / .3),
              value: "Team",
              options: const ["Team", "Requests", "Invites"],
              colNo: 3,
              onPressHandler: (val) {}),
          TeamChatList(),
        ],
      ),
    ));
  }
}
