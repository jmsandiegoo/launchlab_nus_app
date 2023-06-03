import 'package:flutter/material.dart';

class ModalBottomButtonsWidget extends StatelessWidget {
  const ModalBottomButtonsWidget({super.key, required this.buttons});

  final List<Widget> buttons;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [...buttons],
      ),
    );
  }
}

class ModalBottomButton extends StatelessWidget {
  const ModalBottomButton(
      {super.key,
      required this.icon,
      required this.label,
      required this.onPressHandler});

  final IconData icon;
  final String label;
  final Function() onPressHandler;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onPressHandler(),
      titleTextStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
      title: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            Text("  $label"),
          ],
        ),
      ),
    );
  }
}
