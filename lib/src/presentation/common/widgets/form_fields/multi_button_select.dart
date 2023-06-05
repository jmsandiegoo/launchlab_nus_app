import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class MultiButtonSingleSelectWidget<T> extends StatelessWidget {
  const MultiButtonSingleSelectWidget(
      {super.key,
      required this.value,
      required this.options,
      required this.colNo,
      required this.onPressHandler});

  final T value;
  final List<T> options;
  final int colNo;
  final void Function(T) onPressHandler;

  @override
  Widget build(BuildContext context) {
    List<SelectButton> buttons = [];
    for (int i = 0; i < options.length; i++) {
      buttons.add(SelectButton<T>(
          isSelected: options[i] == value,
          label: options[i].toString(),
          value: options[i],
          onPressedHandler: onPressHandler));
    }

    return Expanded(
      child: GridView.count(
        crossAxisSpacing: 20.0,
        childAspectRatio: (1 / .4),
        shrinkWrap: true,
        crossAxisCount: colNo,
        children: [...buttons],
      ),
    );
  }
}

class SelectButton<T> extends StatelessWidget {
  const SelectButton(
      {super.key,
      required this.isSelected,
      required this.label,
      required this.value,
      required this.onPressedHandler});

  final bool isSelected;
  final String label;
  final T value;
  final void Function(T) onPressedHandler;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: () => onPressedHandler(value),
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? blackColor : whiteColor,
        ),
        child: bodyText(label,
            size: 12.0, color: isSelected ? whiteColor : blackColor));
  }
}
