import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class ChatMessageBar extends StatefulWidget {
  const ChatMessageBar({
    super.key,
    required this.messageDraft,
    required this.onChangedHandler,
    required this.onSubmitHandler,
  });

  final String messageDraft;
  final void Function(String) onChangedHandler;
  final void Function() onSubmitHandler;

  @override
  State<ChatMessageBar> createState() => _ChatMessageBarState();
}

class _ChatMessageBarState extends State<ChatMessageBar> {
  final _newMessageFocusNode = FocusNode();
  final _newMessageController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    _newMessageFocusNode.dispose();
    _newMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: whiteColor,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextFieldWidget(
                  endSpacing: false,
                  focusNode: _newMessageFocusNode,
                  onChangedHandler: widget.onChangedHandler,
                  label: "",
                  value: widget.messageDraft,
                  hint: "Enter Message",
                  maxLines: 6,
                  controller: _newMessageController),
            ),
            const SizedBox(
              width: 20.0,
            ),
            secondaryIconButton(
                context, widget.onSubmitHandler, Icons.arrow_right_alt_outlined,
                elevation: 0),
          ],
        ));
  }
}
