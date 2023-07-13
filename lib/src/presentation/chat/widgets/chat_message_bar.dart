import 'package:flutter/material.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class ChatMessageBar extends StatelessWidget {
  const ChatMessageBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Row(
          children: [
            Expanded(
              child: TextFieldWidget(
                  endSpacing: false,
                  focusNode: FocusNode(),
                  onChangedHandler: (val) {},
                  label: "",
                  value: "",
                  hint: "Enter Message",
                  controller: TextEditingController()),
            ),
            const SizedBox(
              width: 20.0,
            ),
            secondaryIconButton(
                context, () => null, Icons.arrow_right_alt_outlined),
          ],
        ));
  }
}
